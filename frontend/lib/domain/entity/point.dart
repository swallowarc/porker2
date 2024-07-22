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
      return "☕";
    default:
      throw UnexpectedError("Invalid Point: $point");
  }
}
