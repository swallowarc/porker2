import 'package:porker2fe/domain/room.dart';

/// 投票できる値。数値を持つものと、数値を持たない特殊な札 (?, ☕) がある。
enum Point {
  /// 未投票
  unspecified('', '', null),
  p0('0', 'Kids', 0),
  p0_5('1/2', 'XXS', 0.5),
  p1('1', 'XS', 1),
  p2('2', 'S', 2),
  p3('3', 'M', 3),
  p5('5', 'L', 5),
  p8('8', 'XL', 8),
  p13('13', 'XXL', 13),
  p21('21', '3XL', 21),
  question('?', '?', null),
  coffee('☕', '☕', null);

  const Point(this.label, this.tshirtLabel, this.value);

  /// ポイント表示のときの札の文字
  final String label;

  /// T シャツ表示のときの札の文字
  final String tshirtLabel;

  /// 平均の計算に使う数値。特殊な札と未投票は null。
  final double? value;

  /// 数値を持つ (平均の計算に含める) か
  bool get isNumeric => value != null;

  /// 投票済みか
  bool get isVoted => this != unspecified;

  String display(DisplayMode mode) =>
      mode == DisplayMode.tshirt ? tshirtLabel : label;

  /// 数値を持つ札を小さい順に並べたもの (手札の並び)
  static const numeric = [p0, p0_5, p1, p2, p3, p5, p8, p13, p21];

  /// 数値を持たない札 (手札の並び)
  static const extras = [coffee, question];
}

/// 平均値に対応する T シャツサイズ。ちょうどの値は単一サイズ、間の値は "S-M" のような範囲で表す。
String averageToTshirtSize(double average) {
  for (final p in Point.numeric) {
    if (average == p.value) {
      return p.tshirtLabel;
    }
  }

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
