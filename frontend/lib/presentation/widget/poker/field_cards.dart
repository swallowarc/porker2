import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:porker2fe/presentation/provider/provider.dart';
import 'package:porker2fe/presentation/widget/poker/field_card.dart';

class FieldCards extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poker = ref.watch(pokerProvider);

    final List<Widget> cards = poker.ballots
        .map(
          (e) => Expanded(
            child: Column(
              children: [
                Container(
                  child: FieldCard(
                    delayMilliseconds: Random(this.hashCode).nextInt(500),
                    point: e.point,
                    loginID: e.userId,
                    loginName: e.userName,
                    opened: poker.opened,
                  ),
                ),
                Text(e.userName),
              ],
            ),
          ),
        )
        .toList();

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 30),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: cards,
        ),
      ),
    );
  }
}
