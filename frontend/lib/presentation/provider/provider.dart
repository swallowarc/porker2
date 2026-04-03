import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/application/direct_room_join.dart';
import 'package:porker2fe/application/poker.dart';
import 'package:porker2fe/application/user.dart';

// Re-export core providers so existing imports continue to work
export 'package:porker2fe/core/provider/providers.dart';

/// application layer ----------------------------------------------------------

final userProvider =
    NotifierProvider<User, UserState>(User.new);

final pokerProvider =
    NotifierProvider<Poker, PokerState>(Poker.new);

final directRoomJoinProvider =
    NotifierProvider<DirectRoomJoin, DirectRoomJoinState>(DirectRoomJoin.new);
