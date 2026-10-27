import 'package:porker2fe/core/error/error.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart'
    as pb;

/// protobuf のメッセージ / 列挙とドメインの型を相互変換する。
/// サーバーから届いた値が既知の列挙に当てはまらない場合は UnexpectedError にする
/// (静かに既定値へ丸めると画面の表示が嘘になる)。

Point pointFromPb(pb.Point p) => switch (p) {
      pb.Point.POINT_UNSPECIFIED => Point.unspecified,
      pb.Point.POINT_0 => Point.p0,
      pb.Point.POINT_0_5 => Point.p0_5,
      pb.Point.POINT_1 => Point.p1,
      pb.Point.POINT_2 => Point.p2,
      pb.Point.POINT_3 => Point.p3,
      pb.Point.POINT_5 => Point.p5,
      pb.Point.POINT_8 => Point.p8,
      pb.Point.POINT_13 => Point.p13,
      pb.Point.POINT_21 => Point.p21,
      pb.Point.POINT_QUESTION => Point.question,
      pb.Point.POINT_COFFEE => Point.coffee,
      _ => throw UnexpectedError('unknown point: $p'),
    };

pb.Point pointToPb(Point p) => switch (p) {
      Point.unspecified => pb.Point.POINT_UNSPECIFIED,
      Point.p0 => pb.Point.POINT_0,
      Point.p0_5 => pb.Point.POINT_0_5,
      Point.p1 => pb.Point.POINT_1,
      Point.p2 => pb.Point.POINT_2,
      Point.p3 => pb.Point.POINT_3,
      Point.p5 => pb.Point.POINT_5,
      Point.p8 => pb.Point.POINT_8,
      Point.p13 => pb.Point.POINT_13,
      Point.p21 => pb.Point.POINT_21,
      Point.question => pb.Point.POINT_QUESTION,
      Point.coffee => pb.Point.POINT_COFFEE,
    };

DisplayMode displayModeFromPb(pb.DisplayMode m) => switch (m) {
      pb.DisplayMode.DISPLAY_MODE_POINT => DisplayMode.point,
      pb.DisplayMode.DISPLAY_MODE_TSHIRT => DisplayMode.tshirt,
      _ => throw UnexpectedError('unknown display mode: $m'),
    };

pb.DisplayMode displayModeToPb(DisplayMode m) => switch (m) {
      DisplayMode.point => pb.DisplayMode.DISPLAY_MODE_POINT,
      DisplayMode.tshirt => pb.DisplayMode.DISPLAY_MODE_TSHIRT,
    };

VoteState voteStateFromPb(pb.VoteState s) => switch (s) {
      pb.VoteState.VOTE_STATE_HIDE => VoteState.hide,
      pb.VoteState.VOTE_STATE_OPEN => VoteState.open,
      _ => throw UnexpectedError('unknown vote state: $s'),
    };

UserRole userRoleFromPb(pb.UserRole r) => switch (r) {
      pb.UserRole.USER_ROLE_VOTER => UserRole.voter,
      pb.UserRole.USER_ROLE_OBSERVER => UserRole.observer,
      _ => throw UnexpectedError('unknown user role: $r'),
    };

Ballot ballotFromPb(pb.Ballot b) => Ballot(
      userID: b.userId,
      userName: b.userName,
      point: pointFromPb(b.point),
      role: userRoleFromPb(b.role),
    );

Room roomFromPb(pb.RoomCondition c) => Room(
      roomID: c.roomId,
      adminUserID: c.adminUserId,
      ballots: c.ballots.map(ballotFromPb).toList(growable: false),
      voteState: voteStateFromPb(c.voteState),
      autoOpen: c.autoOpen,
      displayMode: displayModeFromPb(c.displayMode),
    );
