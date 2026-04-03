import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/domain/usecase/direct_room_join.dart';
import 'package:porker2fe/domain/usecase/poker.dart';
import 'package:porker2fe/domain/usecase/user.dart';

// Re-export repository providers so existing imports continue to work
export 'package:porker2fe/core/provider/repository_providers.dart';

/// domain layer ---------------------------------------------------------------

/// usecase

final userProvider =
    NotifierProvider<User, UserState>(User.new);

final pokerProvider =
    NotifierProvider<Poker, PokerState>(Poker.new);

final directRoomJoinProvider =
    NotifierProvider<DirectRoomJoin, DirectRoomJoinState>(DirectRoomJoin.new);
