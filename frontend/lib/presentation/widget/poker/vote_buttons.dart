import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/provider/provider.dart';

class VoteButtons extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poker = ref.watch(pokerProvider.notifier);

    return Center(
      child: Container(
        width: 400,
        alignment: Alignment.center,
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.group),
                label: const Text('Open'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: poker.openable ? () => poker.showVotes() : null,
              ),
            ),
            SizedBox(
              width: 150,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.lightBlue,
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                ),
                onPressed: () {
                  poker.resetVotes();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
