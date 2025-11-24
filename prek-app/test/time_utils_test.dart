import 'package:_2025_prek/utils/time_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('sameDay', () {
    test('returns true for same calendar day with different times', () {
      final a = DateTime(2024, 10, 5, 8, 30);
      final b = DateTime(2024, 10, 5, 23, 45);
      expect(sameDay(a, b), isTrue);
    });

    test('returns false for different calendar days', () {
      final a = DateTime(2024, 10, 5, 23, 59);
      final b = DateTime(2024, 10, 6, 0, 0);
      expect(sameDay(a, b), isFalse);
    });
  });

  group('friendlyTime', () {
    final now = DateTime(2024, 10, 5, 12, 0);

    test('formats today label with time', () {
      final dt = DateTime(2024, 10, 5, 9, 30);
      expect(friendlyTime(dt, now: now), 'Today · 09:30');
    });

    test('formats yesterday label', () {
      final dt = DateTime(2024, 10, 4, 21, 5);
      expect(friendlyTime(dt, now: now), 'Yesterday · 21:05');
    });

    test('formats days ago label', () {
      final dt = DateTime(2024, 9, 30, 7, 1);
      expect(friendlyTime(dt, now: now), '5 days ago · 07:01');
    });
  });

  group('formatMmSs', () {
    test('pads minutes and seconds to two digits', () {
      expect(formatMmSs(const Duration(minutes: 1, seconds: 2)), '01:02');
      expect(formatMmSs(const Duration(minutes: 59, seconds: 59)), '59:59');
      expect(formatMmSs(const Duration(seconds: 7)), '00:07');
    });
  });
}
