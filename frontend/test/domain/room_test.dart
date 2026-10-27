import 'package:flutter_test/flutter_test.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/domain/room.dart';

Room _room({
  VoteState voteState = VoteState.hide,
  List<Ballot> ballots = const [],
}) =>
    Room.empty.copyWith(roomID: '11111', voteState: voteState, ballots: ballots);

Ballot _ballot(String userID, Point point, {UserRole role = UserRole.voter}) =>
    Ballot(userID: userID, userName: userID, point: point, role: role);

void main() {
  test('empty room', () {
    expect(Room.empty.isEmpty, isTrue);
    expect(_room().isEmpty, isFalse);
  });

  test('openable requires a hidden state and at least one vote', () {
    expect(_room(ballots: [_ballot('a', Point.unspecified)]).openable, isFalse);
    expect(_room(ballots: [_ballot('a', Point.p3)]).openable, isTrue);
    expect(
      _room(voteState: VoteState.open, ballots: [_ballot('a', Point.p3)])
          .openable,
      isFalse,
    );
  });

  test('votable and opened follow the vote state', () {
    expect(_room().votable, isTrue);
    expect(_room().opened, isFalse);
    expect(_room(voteState: VoteState.open).votable, isFalse);
    expect(_room(voteState: VoteState.open).opened, isTrue);
  });

  test('average ignores observers and non-numeric points', () {
    final room = _room(ballots: [
      _ballot('a', Point.p3),
      _ballot('b', Point.p5),
      _ballot('c', Point.question),
      _ballot('d', Point.p21, role: UserRole.observer),
    ]);
    expect(room.average, 4.0);
    expect(room.numericVoteCount, 2);
    expect(room.voters.length, 3);
    expect(room.observerCount, 1);
  });

  test('average is 0 when nobody voted a number', () {
    expect(_room().average, 0);
    expect(_room(ballots: [_ballot('a', Point.coffee)]).average, 0);
  });

  test('isUnanimity needs an open state and two or more equal voter points',
      () {
    final same = [_ballot('a', Point.p3), _ballot('b', Point.p3)];

    expect(_room(ballots: same).isUnanimity, isFalse, reason: 'hidden');
    expect(_room(voteState: VoteState.open, ballots: same).isUnanimity, isTrue);
    expect(
      _room(voteState: VoteState.open, ballots: [...same, _ballot('c', Point.p5)])
          .isUnanimity,
      isFalse,
    );
    expect(
      _room(voteState: VoteState.open, ballots: [_ballot('a', Point.p3)])
          .isUnanimity,
      isFalse,
      reason: 'single voter',
    );
    expect(
      _room(voteState: VoteState.open, ballots: [
        ...same,
        _ballot('o', Point.unspecified, role: UserRole.observer),
      ]).isUnanimity,
      isTrue,
      reason: 'observers are ignored',
    );
    expect(
      _room(voteState: VoteState.open, ballots: [
        _ballot('a', Point.unspecified),
        _ballot('b', Point.unspecified),
      ]).isUnanimity,
      isFalse,
      reason: 'unvoted is not unanimity',
    );
  });

  test('pointOf and isObserver look up the ballot by user id', () {
    final room = _room(ballots: [
      _ballot('a', Point.p8),
      _ballot('o', Point.unspecified, role: UserRole.observer),
    ]);
    expect(room.pointOf('a'), Point.p8);
    expect(room.pointOf('zzz'), Point.unspecified);
    expect(room.isObserver('o'), isTrue);
    expect(room.isObserver('a'), isFalse);
    expect(room.isObserver('zzz'), isFalse);
  });
}
