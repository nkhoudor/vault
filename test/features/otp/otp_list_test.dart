import 'dart:async';

import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/otp_list/otp_list_presenter.dart';
import 'package:app_core/features/otp/otp_list/otp_list_state.dart';
import 'package:app_core/features/otp/otp_list/otp_list_widget.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_slidable_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

OtpDisplayable _otp(String name, {String account = ''}) => OtpDisplayable(
  id: 'id-$name',
  name: name,
  account: account,
  code: '123456',
  createdAt: DateTime(2020, 1, 1, 12),
  expiresAt: DateTime(2020, 1, 1, 11),
);

final _items = [_otp('GitHub', account: 'work@example.com'), _otp('Google'), _otp('GitLab')];

void main() {
  late MockOtpListRepository repository;
  late MockWatchOtpListUseCase watchOtpList;

  setUp(() {
    repository = MockOtpListRepository();
    watchOtpList = MockWatchOtpListUseCase();
    when(() => watchOtpList()).thenAnswer((_) => Stream.value(_items));
    when(() => repository.removeSecret(any())).thenAnswer((_) async {});
    when(() => repository.copyCode(any())).thenAnswer((_) async {});
  });

  OtpListPresenter buildPresenter({String searchQuery = ''}) => OtpListPresenter(
    OtpListState(otpList: _items, searchQuery: searchQuery),
    MockOtpListNavigator(),
    repository,
    watchOtpList,
  );

  group('OtpListState.visibleEntries', () {
    test('returns every entry when the query is blank', () {
      final state = OtpListState(otpList: _items, searchQuery: '  ');

      expect(state.visibleEntries, _items);
      expect(state.isSearching, isFalse);
    });

    test('matches a case-insensitive substring', () {
      final state = OtpListState(otpList: _items, searchQuery: ' gIt ');

      expect(state.visibleEntries.map((otp) => otp.name), ['GitHub', 'GitLab']);
    });

    test('matches the account as well as the name', () {
      final state = OtpListState(otpList: _items, searchQuery: 'WORK@');

      expect(state.visibleEntries.map((otp) => otp.name), ['GitHub']);
    });

    test('is empty when nothing matches', () {
      final state = OtpListState(otpList: _items, searchQuery: 'aws');

      expect(state.visibleEntries, isEmpty);
      expect(state.isSearching, isTrue);
    });
  });

  group('OtpListPresenter', () {
    test('onSearchChanged updates the query and keeps the list', () {
      final presenter = buildPresenter()..onSearchChanged('goo');

      expect(presenter.state.searchQuery, 'goo');
      expect(presenter.state.otpList, _items);
    });

    test('an empty list from the repository clears the search query', () async {
      when(() => watchOtpList()).thenAnswer((_) => Stream.value(const <OtpDisplayable>[]));
      final presenter = buildPresenter(searchQuery: 'goo');

      await Future<void>.delayed(Duration.zero);

      expect(presenter.state.searchQuery, isEmpty);
      expect(presenter.state.isSearching, isFalse);
    });

    test('a new list from the repository keeps the search query', () async {
      final presenter = buildPresenter(searchQuery: 'goo');

      await Future<void>.delayed(Duration.zero);

      expect(presenter.state.searchQuery, 'goo');
    });

    test('onCodeTapped copies the code of the entry', () async {
      await buildPresenter().onCodeTapped(_items[0]);

      verify(() => repository.copyCode('123456')).called(1);
    });

    test('onDeleteConfirmed removes the secret with the id of the entry', () async {
      await buildPresenter().onDeleteConfirmed(_items[2]);

      verify(() => repository.removeSecret('id-GitLab')).called(1);
    });
  });

  group('OtpListWidget', () {
    Future<void> pumpList(WidgetTester tester) => tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        home: Scaffold(body: OtpListWidget(presenter: buildPresenter())),
      ),
    );

    Future<void> swipeAndTapDelete(WidgetTester tester, String name) async {
      await tester.drag(find.text(name), const Offset(-300, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
    }

    testWidgets('tapping an entry copies its code and says so', (tester) async {
      await pumpList(tester);

      await tester.tap(find.text('Google'));
      await tester.pump();

      verify(() => repository.copyCode('123456')).called(1);
      expect(find.text('Code copied to clipboard'), findsOneWidget);
    });

    testWidgets('typing in the search field filters the list', (tester) async {
      await pumpList(tester);

      await tester.enterText(find.byType(TextField), 'git');
      await tester.pumpAndSettle();

      expect(find.byType(OtpSlidableListItem), findsNWidgets(2));
      expect(find.text('Google'), findsNothing);
    });

    testWidgets('the clear button empties the field and shows every entry again', (tester) async {
      await pumpList(tester);
      await tester.enterText(find.byType(TextField), 'git');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
      expect(find.byType(OtpSlidableListItem), findsNWidgets(3));
      expect(find.byIcon(Icons.clear), findsNothing);
    });

    testWidgets('shows a message when nothing matches', (tester) async {
      await pumpList(tester);

      await tester.enterText(find.byType(TextField), 'aws');
      await tester.pumpAndSettle();

      expect(find.text('No matching accounts'), findsOneWidget);
    });

    testWidgets('deleting from a filtered list removes that entry', (tester) async {
      await pumpList(tester);
      await tester.enterText(find.byType(TextField), 'gitlab');
      await tester.pumpAndSettle();

      await swipeAndTapDelete(tester, 'GitLab');
      expect(find.text('Delete this code?'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      verify(() => repository.removeSecret('id-GitLab')).called(1);
    });

    testWidgets('deleting the last entry while searching leaves no search message behind', (tester) async {
      final lists = StreamController<Iterable<OtpDisplayable>>();
      addTearDown(lists.close);
      when(() => watchOtpList()).thenAnswer((_) => lists.stream);
      await pumpList(tester);
      lists.add(_items);
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'git');
      await tester.pumpAndSettle();

      lists.add(const []);
      await tester.pumpAndSettle();

      expect(find.text('No matching accounts'), findsNothing);
    });

    testWidgets('the confirmation names the service and the account', (tester) async {
      await pumpList(tester);

      await swipeAndTapDelete(tester, 'GitHub');

      expect(find.textContaining('GitHub (work@example.com)'), findsOneWidget);
    });

    testWidgets('cancelling the confirmation deletes nothing', (tester) async {
      await pumpList(tester);

      await swipeAndTapDelete(tester, 'Google');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => repository.removeSecret(any()));
    });
  });
}
