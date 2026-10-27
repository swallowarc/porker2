import 'package:flutter_test/flutter_test.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/domain/room.dart';

void main() {
  group('Point', () {
    test('numeric points carry their value and labels in ascending order', () {
      expect(Point.numeric.map((p) => p.value), [0, 0.5, 1, 2, 3, 5, 8, 13, 21]);
      expect(Point.numeric.map((p) => p.label),
          ['0', '1/2', '1', '2', '3', '5', '8', '13', '21']);
      expect(Point.numeric.map((p) => p.tshirtLabel),
          ['Kids', 'XXS', 'XS', 'S', 'M', 'L', 'XL', 'XXL', '3XL']);
      expect(Point.numeric.every((p) => p.isNumeric && p.isVoted), isTrue);
    });

    test('extras are voted but not numeric', () {
      for (final p in Point.extras) {
        expect(p.isVoted, isTrue, reason: p.name);
        expect(p.isNumeric, isFalse, reason: p.name);
        expect(p.value, isNull, reason: p.name);
      }
      expect(Point.question.label, '?');
      expect(Point.coffee.label, '☕');
    });

    test('unspecified is neither voted nor numeric', () {
      expect(Point.unspecified.isVoted, isFalse);
      expect(Point.unspecified.isNumeric, isFalse);
    });

    test('every point is either unspecified, numeric or extra', () {
      expect(
        {...Point.numeric, ...Point.extras, Point.unspecified},
        Point.values.toSet(),
      );
    });

    test('display follows the display mode', () {
      expect(Point.p3.display(DisplayMode.point), '3');
      expect(Point.p3.display(DisplayMode.tshirt), 'M');
      for (final mode in DisplayMode.values) {
        expect(Point.question.display(mode), '?');
        expect(Point.coffee.display(mode), '☕');
      }
    });
  });

  group('averageToTshirtSize', () {
    test('maps exact averages to single sizes', () {
      for (final p in Point.numeric) {
        expect(averageToTshirtSize(p.value!), p.tshirtLabel, reason: p.name);
      }
    });

    test('maps boundary values to expected sizes', () {
      expect(averageToTshirtSize(-0.1), 'Kids');
      expect(averageToTshirtSize(0.24), 'Kids');
      expect(averageToTshirtSize(0.25), 'Kids-XXS');
      expect(averageToTshirtSize(2.5), 'S-M');
      expect(averageToTshirtSize(20.99), 'XXL-3XL');
      expect(averageToTshirtSize(21.1), '3XL');
    });
  });
}
