import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'direct_room_join.freezed.dart';

@freezed
class DirectRoomJoinState with _$DirectRoomJoinState {
  const factory DirectRoomJoinState(
    String presetRoomID,
  ) = _DirectRoomJoinState;
}

class DirectRoomJoin extends StateNotifier<DirectRoomJoinState> {
  DirectRoomJoin() : super(const DirectRoomJoinState(""));

  String popPresetRoomID() {
    final presetRoomID = state.presetRoomID;
    if (presetRoomID.isNotEmpty) {
      state = state.copyWith(presetRoomID: "");
    }
    return presetRoomID;
  }

  void setPresetRoomID(String roomID) {
    state = state.copyWith(presetRoomID: roomID);
  }

  bool get hasPresetRoomID => state.presetRoomID.isNotEmpty;
}
