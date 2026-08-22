import 'package:flutter_test/flutter_test.dart';
import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';

void main() {
  group('pointFromPb', () {
    test('returns numeric label for each point', () {
      expect(pointFromPb(Point.POINT_0), '0');
      expect(pointFromPb(Point.POINT_0_5), '1/2');
      expect(pointFromPb(Point.POINT_1), '1');
      expect(pointFromPb(Point.POINT_2), '2');
      expect(pointFromPb(Point.POINT_3), '3');
      expect(pointFromPb(Point.POINT_5), '5');
      expect(pointFromPb(Point.POINT_8), '8');
      expect(pointFromPb(Point.POINT_13), '13');
      expect(pointFromPb(Point.POINT_21), '21');
    });

    test('returns numeric label for each point', () {
      expect(pointFromPb(Point.POINT_3), '3');
    });

    test('returns special labels', () {
      expect(pointFromPb(Point.POINT_QUESTION), '?');
      expect(pointFromPb(Point.POINT_COFFEE), '☕');
    });

    test('throws UnexpectedError for unknown point', () {
      expect(
        () => pointFromPb(Point.POINT_UNSPECIFIED),
        throwsA(isA<UnexpectedError>()),
      );
    });
  });

  group('pointFromPbDisplay', () {
    test('returns point label when display mode is point', () {
      expect(
        pointFromPbDisplay(Point.POINT_3, DisplayMode.DISPLAY_MODE_POINT),
        '3',
      );
    });

    test('returns T-shirt size label when display mode is T-shirt', () {
      expect(
        pointFromPbDisplay(Point.POINT_0, DisplayMode.DISPLAY_MODE_TSHIRT),
        'Kids',
      );
      expect(
        pointFromPbDisplay(Point.POINT_0_5, DisplayMode.DISPLAY_MODE_TSHIRT),
        'XXS',
      );
      expect(
        pointFromPbDisplay(Point.POINT_5, DisplayMode.DISPLAY_MODE_TSHIRT),
        'L',
      );
      expect(
        pointFromPbDisplay(Point.POINT_21, DisplayMode.DISPLAY_MODE_TSHIRT),
        '3XL',
      );
    });

    test('returns special labels regardless of display mode', () {
      for (final mode in DisplayMode.values) {
        expect(pointFromPbDisplay(Point.POINT_QUESTION, mode), '?');
        expect(pointFromPbDisplay(Point.POINT_COFFEE, mode), '☕');
      }
    });
  });

  group('validPoint', () {
    test('returns true for votable points', () {
      expect(validPoint(Point.POINT_0), isTrue);
      expect(validPoint(Point.POINT_0_5), isTrue);
      expect(validPoint(Point.POINT_1), isTrue);
      expect(validPoint(Point.POINT_21), isTrue);
    });

    test('returns false for special and unspecified points', () {
      expect(validPoint(Point.POINT_QUESTION), isFalse);
      expect(validPoint(Point.POINT_COFFEE), isFalse);
      expect(validPoint(Point.POINT_UNSPECIFIED), isFalse);
    });
  });

  group('pointToDouble', () {
    test('maps each point to its numeric value', () {
      expect(pointToDouble(Point.POINT_0), 0.0);
      expect(pointToDouble(Point.POINT_0_5), 0.5);
      expect(pointToDouble(Point.POINT_1), 1.0);
      expect(pointToDouble(Point.POINT_2), 2.0);
      expect(pointToDouble(Point.POINT_3), 3.0);
      expect(pointToDouble(Point.POINT_5), 5.0);
      expect(pointToDouble(Point.POINT_8), 8.0);
      expect(pointToDouble(Point.POINT_13), 13.0);
      expect(pointToDouble(Point.POINT_21), 21.0);
    });

    test('throws UnexpectedError for non-numeric points', () {
      expect(
        () => pointToDouble(Point.POINT_QUESTION),
        throwsA(isA<UnexpectedError>()),
      );
    });
  });

  group('averageToTshirtSize', () {
    test('maps exact averages to single sizes', () {
      expect(averageToTshirtSize(0.0), 'Kids');
      expect(averageToTshirtSize(0.5), 'XXS');
      expect(averageToTshirtSize(1.0), 'XS');
      expect(averageToTshirtSize(2.0), 'S');
      expect(averageToTshirtSize(3.0), 'M');
      expect(averageToTshirtSize(5.0), 'L');
      expect(averageToTshirtSize(8.0), 'XL');
      expect(averageToTshirtSize(13.0), 'XXL');
      expect(averageToTshirtSize(21.0), '3XL');
    });

    test('maps boundary values to expected sizes', () {
      expect(averageToTshirtSize(-0.1), 'Kids');
      expect(averageToTshirtSize(0.24), 'Kids');
      expect(averageToTshirtSize(0.25), 'Kids-XXS');
      expect(averageToTshirtSize(20.99), 'XXL-3XL');
      expect(averageToTshirtSize(21.1), '3XL');
    });
  });
