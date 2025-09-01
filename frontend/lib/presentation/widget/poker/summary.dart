import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/data/datasource/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/entity/point.dart';
import 'package:porker2fe/presentation/provider/provider.dart';

class Summary extends HookConsumerWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poker = ref.watch(pokerProvider);

    if (poker.voteState != VoteState.VOTE_STATE_OPEN) {
      // Show participant counts even when votes are hidden
      final voterCount = poker.ballots
          .where((e) => e.role != UserRole.USER_ROLE_OBSERVER)
          .length;
      final observerCount = poker.ballots
          .where((e) => e.role == UserRole.USER_ROLE_OBSERVER)
          .length;

      return Column(
        children: [
          const Text(" ", style: TextStyle(fontSize: 17)),
          Text(
            "$voterCount voters, $observerCount observers",
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      );
    }

    // Only count votes from non-observers
    final voterBallots = poker.ballots
        .where((e) => e.role != UserRole.USER_ROLE_OBSERVER)
        .toList();
    final observerCount = poker.ballots
        .where((e) => e.role == UserRole.USER_ROLE_OBSERVER)
        .length;

    final validVotes = voterBallots.where((e) => validPoint(e.point)).length;

    final double total = voterBallots.fold(0, (prev, e) {
      if (validPoint(e.point)) {
        return prev + pointToDouble(e.point);
      } else {
        return prev;
      }
    });
    final double average = validVotes > 0 ? total / validVotes : 0;

    String displayText;
    if (poker.displayMode == DisplayMode.DISPLAY_MODE_TSHIRT) {
      final tshirtSize = averageToTshirtSize(average);
      displayText = "Avg: $tshirtSize (${average.toStringAsFixed(1)})";
    } else {
      displayText = "Avg: ${average.toStringAsFixed(1)}";
    }

    return Column(
      children: [
        Text(displayText,
            style: const TextStyle(fontSize: 17, color: Colors.green)),
        const SizedBox(height: 4),
        Text(
          "$validVotes voters${observerCount > 0 ? ', $observerCount observers' : ''}",
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}
