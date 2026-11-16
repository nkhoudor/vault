import 'dart:async';

import 'package:app_core/app/l10n_delegates.dart';
import 'package:app_core/features/otp/domain/model/otp.dart';
import 'package:app_core/features/otp/otp_list/otp_list_presenter.dart';
import 'package:app_core/features/otp/otp_list/otp_list_state.dart';
import 'package:app_core/features/otp/otp_list/otp_list_widget.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_account_chip.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_dial.dart';
import 'package:app_core/features/otp/otp_list/widgets/otp_setup_steps.dart';
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

  group('OtpListState without accounts', () {
    test('is loading until a list arrives', () {
      const state = OtpListState();

      expect(state.isLoading, isTrue);
      expect(state.hasNoAccounts, isFalse);
      expect(state.visibleEntries, isEmpty);
    });

    test('has no accounts once an empty list arrived', () {
      const state = OtpListState(otpList: []);

      expect(state.isLoading, isFalse);
      expect(state.hasNoAccounts, isTrue);
    });
  });

  group('OtpListState.selectedEntry', () {
    test('is the first entry until one is picked', () {
      expect(OtpListState(otpList: _items).selectedEntry, _items[0]);
    });

    test('is the picked entry while it is visible', () {
      expect(OtpListState(otpList: _items, selectedId: 'id-GitLab').selectedEntry, _items[2]);
    });

    test('is the first visible entry when the picked one is filtered out', () {
      final state = OtpListState(otpList: _items, selectedId: 'id-Google', searchQuery: 'git');

      expect(state.selectedEntry, _items[0]);
    });

    test('is null when nothing is visible', () {
      expect(OtpListState(otpList: _items, searchQuery: 'aws').selectedEntry, isNull);
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

    test('onAccountSelected makes that entry the selected one', () {
      final presenter = buildPresenter()..onAccountSelected(_items[1]);

      expect(presenter.state.selectedEntry, _items[1]);
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
    Future<void> pumpList(WidgetTester tester, {OtpListPresenter? presenter}) => tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: localizationsDelegates,
        supportedLocales: supportedLocales,
        home: Scaffold(
          body: OtpListWidget(
            presenter: presenter ?? buildPresenter(),
            trailingBuilder: (_, expansion) => Text('expansion $expansion'),
          ),
        ),
      ),
    );

    OtpListPresenter presenterFor(Stream<Iterable<OtpDisplayable>> lists) {
      when(() => watchOtpList()).thenAnswer((_) => lists);
      return OtpListPresenter(const OtpListState(), MockOtpListNavigator(), repository, watchOtpList);
    }

    Finder chip(String name) => find.widgetWithText(OtpAccountChip, name);

    Finder inDial(String text) => find.descendant(of: find.byType(OtpDial), matching: find.text(text));

    Future<void> longPress(WidgetTester tester, String name) async {
      await tester.longPress(chip(name));
      await tester.pumpAndSettle();
    }

    testWidgets('shows neither the steps nor the trailing widget until the accounts have been read', (tester) async {
      final lists = StreamController<Iterable<OtpDisplayable>>();
      addTearDown(lists.close);

      await pumpList(tester, presenter: presenterFor(lists.stream));

      expect(find.byType(OtpSetupSteps), findsNothing);
      expect(find.textContaining('expansion'), findsNothing);
    });

    testWidgets('without accounts it shows the setup steps and gives the trailing widget the whole row', (
      tester,
    ) async {
      await pumpList(tester, presenter: presenterFor(Stream.value(const [])));
      await tester.pump();

      expect(find.text('Set up your first code'), findsOneWidget);
      expect(find.text('expansion 1.0'), findsOneWidget);
      expect(find.byType(TextField), findsNothing);
      expect(tester.getSize(find.text('expansion 1.0')).width, 800 - 40);
    });

    testWidgets('with accounts the trailing widget shares the row with the search field', (tester) async {
      await pumpList(tester);

      expect(find.byType(OtpSetupSteps), findsNothing);
      expect(find.text('expansion 0.0'), findsOneWidget);
      expect(tester.getSize(find.text('expansion 0.0')).width, 52);
    });

    testWidgets('deleting the last account brings the setup steps back', (tester) async {
      final lists = StreamController<Iterable<OtpDisplayable>>();
      addTearDown(lists.close);
      await pumpList(tester, presenter: presenterFor(lists.stream));
      lists.add(_items);
      await tester.pumpAndSettle();
      expect(find.byType(OtpDial), findsOneWidget);

      lists.add(const []);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(find.byType(OtpDial), findsOneWidget);
      expect(find.byType(OtpSetupSteps), findsOneWidget);

      await tester.pumpAndSettle();

      expect(find.byType(OtpDial), findsNothing);
      expect(find.text('expansion 1.0'), findsOneWidget);
    });

    testWidgets('the dial shows the first entry', (tester) async {
      await pumpList(tester);

      expect(inDial('GitHub'), findsOneWidget);
      expect(inDial('work@example.com'), findsOneWidget);
    });

    testWidgets('tapping an account shows it in the dial', (tester) async {
      await pumpList(tester);

      await tester.tap(chip('Google'));
      await tester.pump();

      expect(inDial('Google'), findsOneWidget);
      verifyNever(() => repository.copyCode(any()));
    });

    testWidgets('tapping the dial copies its code and says so', (tester) async {
      await pumpList(tester);

      await tester.tap(find.byType(OtpDial));
      await tester.pump();

      verify(() => repository.copyCode('123456')).called(1);
      expect(find.text('Code copied to clipboard'), findsOneWidget);
    });

    testWidgets('the dial falls back to the first match when the picked account is filtered out', (tester) async {
      await pumpList(tester);
      await tester.tap(chip('Google'));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'gitlab');
      await tester.pumpAndSettle();

      expect(inDial('GitLab'), findsOneWidget);
    });

    testWidgets('typing in the search field filters the list', (tester) async {
      await pumpList(tester);

      await tester.enterText(find.byType(TextField), 'git');
      await tester.pumpAndSettle();

      expect(find.byType(OtpAccountChip), findsNWidgets(2));
      expect(chip('Google'), findsNothing);
    });

    testWidgets('the clear button empties the field and shows every entry again', (tester) async {
      await pumpList(tester);
      await tester.enterText(find.byType(TextField), 'git');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(tester.widget<TextField>(find.byType(TextField)).controller!.text, isEmpty);
      expect(find.byType(OtpAccountChip), findsNWidgets(3));
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

      await longPress(tester, 'GitLab');
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

      await longPress(tester, 'GitHub');

      expect(find.textContaining('GitHub (work@example.com)'), findsOneWidget);
    });

    testWidgets('cancelling the confirmation deletes nothing', (tester) async {
      await pumpList(tester);

      await longPress(tester, 'Google');
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(() => repository.removeSecret(any()));
    });
  });
}
