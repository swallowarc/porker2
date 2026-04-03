import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/infrastructure/generated/pb/porker/v2/domain.pb.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/presentation/provider/provider.dart';

class Summary extends HookConsumerWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poker = ref.watch(pokerProvider);
    final pokerNotifier = ref.read(pokerProvider.notifier);

    if (poker.voteState != VoteState.VOTE_STATE_OPEN) {
      final voterCount = pokerNotifier.voterBallots.length;
      final observerCount = pokerNotifier.observerCount;

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

    final validVotes = pokerNotifier.validVoteCount;
    final average = pokerNotifier.voteAverage;
    final observerCount = pokerNotifier.observerCount;

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
