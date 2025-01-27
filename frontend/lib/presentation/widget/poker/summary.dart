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
      return const Text(" ", style: TextStyle(fontSize: 17));
    }

    final validVotes = poker.ballots.where((e) => validPoint(e.point)).length;

    final double total = poker.ballots.fold(0, (prev, e) {
      if (validPoint(e.point)) {
        return prev + pointToDouble(e.point);
      } else {
        return prev;
      }
    });
    final double average = total / validVotes;

    return Text("Avg: ${average.toStringAsFixed(1)}",
        style: const TextStyle(fontSize: 17, color: Colors.green));
  }
}
