import 'package:app_core/features/otp/otp_list/widgets/otp_account_grid.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OtpAccountGrid.columnsFor', () {
    test('fits 4 columns on a narrow screen, 5 on a regular one and 6 on a wide one', () {
      expect(OtpAccountGrid.columnsFor(width: 280, count: 30), 4);
      expect(OtpAccountGrid.columnsFor(width: 350, count: 30), 5);
      expect(OtpAccountGrid.columnsFor(width: 390, count: 30), 6);
      expect(OtpAccountGrid.columnsFor(width: 1000, count: 30), 6);
    });

    test('puts the accounts in one row while they fit', () {
      expect(OtpAccountGrid.columnsFor(width: 350, count: 1), 1);
      expect(OtpAccountGrid.columnsFor(width: 350, count: 3), 3);
      expect(OtpAccountGrid.columnsFor(width: 350, count: 5), 5);
    });

    test('spreads the accounts evenly over the rows they need', () {
      expect(OtpAccountGrid.columnsFor(width: 350, count: 6), 3);
      expect(OtpAccountGrid.columnsFor(width: 350, count: 8), 4);
      expect(OtpAccountGrid.columnsFor(width: 350, count: 10), 5);
      expect(OtpAccountGrid.columnsFor(width: 350, count: 11), 4);
      expect(OtpAccountGrid.columnsFor(width: 390, count: 7), 4);
    });
  });
}
