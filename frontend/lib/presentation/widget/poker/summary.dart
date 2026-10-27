import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/domain/point.dart';
import 'package:porker2fe/domain/room.dart';
import 'package:porker2fe/application/provider.dart';

class Summary extends HookConsumerWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poker = ref.watch(pokerProvider);

    if (poker.voteState != VoteState.open) {
      final voterCount = poker.voters.length;
      final observerCount = poker.observerCount;

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

    final validVotes = poker.numericVoteCount;
    final average = poker.average;
    final observerCount = poker.observerCount;

    String displayText;
    if (poker.displayMode == DisplayMode.tshirt) {
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
