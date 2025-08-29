import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';

String pointFromPb(Point point) {
  switch (point) {
    case Point.POINT_0:
      return "0";
    case Point.POINT_0_5:
      return "1/2";
    case Point.POINT_1:
      return "1";
    case Point.POINT_2:
      return "2";
    case Point.POINT_3:
      return "3";
    case Point.POINT_5:
      return "5";
    case Point.POINT_8:
      return "8";
    case Point.POINT_13:
      return "13";
    case Point.POINT_21:
      return "21";
    case Point.POINT_QUESTION:
      return "?";
    case Point.POINT_COFFEE:
      return "休";
    default:
      throw UnexpectedError("Invalid Point: $point");
  }
}

String pointFromPbDisplay(Point point, DisplayMode displayMode) {
  if (displayMode == DisplayMode.DISPLAY_MODE_TSHIRT) {
    switch (point) {
      case Point.POINT_0:
        return "Kids";
      case Point.POINT_0_5:
        return "XXS";
      case Point.POINT_1:
        return "XS";
      case Point.POINT_2:
        return "S";
      case Point.POINT_3:
        return "M";
      case Point.POINT_5:
        return "L";
      case Point.POINT_8:
        return "XL";
      case Point.POINT_13:
        return "XXL";
      case Point.POINT_21:
        return "3XL";
      case Point.POINT_QUESTION:
        return "?";
      case Point.POINT_COFFEE:
        return "休";
      default:
        throw UnexpectedError("Invalid Point: $point");
    }
  }
  return pointFromPb(point);
}

bool validPoint(Point point) {
  switch (point) {
    case Point.POINT_0:
    case Point.POINT_0_5:
    case Point.POINT_1:
    case Point.POINT_2:
    case Point.POINT_3:
    case Point.POINT_5:
    case Point.POINT_8:
    case Point.POINT_13:
    case Point.POINT_21:
      return true;
    default:
      return false;
  }
}

double pointToDouble (Point point) {
  switch (point) {
    case Point.POINT_0:
      return 0;
    case Point.POINT_0_5:
      return 0.5;
    case Point.POINT_1:
      return 1;
    case Point.POINT_2:
      return 2;
    case Point.POINT_3:
      return 3;
    case Point.POINT_5:
      return 5;
    case Point.POINT_8:
      return 8;
    case Point.POINT_13:
      return 13;
    case Point.POINT_21:
      return 21;
    default:
      throw UnexpectedError("Invalid Point: $point");
  }
}

String averageToTshirtSize(double average) {
  // Check for exact values first
  if (average == 0.0) {
    return "Kids";
  } else if (average == 0.5) {
    return "XXS";
  } else if (average == 1.0) {
    return "XS";
  } else if (average == 2.0) {
    return "S";
  } else if (average == 3.0) {
    return "M";
  } else if (average == 5.0) {
    return "L";
  } else if (average == 8.0) {
    return "XL";
  } else if (average == 13.0) {
    return "XXL";
  } else if (average == 21.0) {
    return "3XL";
  }
  
  // Handle ranges for non-exact values
  if (average < 0.25) {
    return "Kids";
  } else if (average < 0.5) {
    return "Kids-XXS";
  } else if (average < 0.75) {
    return "XXS";
  } else if (average < 1.0) {
    return "XXS-XS";
  } else if (average < 1.5) {
    return "XS";
  } else if (average < 2.0) {
    return "XS-S";
  } else if (average < 2.5) {
    return "S";
  } else if (average < 3.0) {
    return "S-M";
  } else if (average < 4.0) {
    return "M";
  } else if (average < 5.0) {
    return "M-L";
  } else if (average < 6.5) {
    return "L";
  } else if (average < 8.0) {
    return "L-XL";
  } else if (average < 10.5) {
    return "XL";
  } else if (average < 13.0) {
    return "XL-XXL";
  } else if (average < 17.0) {
    return "XXL";
  } else if (average < 21.0) {
    return "XXL-3XL";
  } else {
    return "3XL";
  }
}
