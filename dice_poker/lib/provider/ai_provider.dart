import 'dart:math';

import 'package:dice_poker/model/dice_hand.dart';
import 'package:dice_poker/model/history_entry.dart';
import 'package:dice_poker/provider/history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final aiProvider = NotifierProvider<AiDiceNotifier, List<int>>(
  AiDiceNotifier.new,
);

class AiDiceNotifier extends Notifier<List<int>> {
  final _random = Random();

  @override
  List<int> build() {
    // TODO: implement build
    return List.generate(5, (_) => _random.nextInt(6) + 1);
  }

  HandRank playTurn() {
    List<int> dice = List.generate(5, (_) => _random.nextInt(6) + 1);

    // 단순히 전체 다 3번 굴리는 전략
    for (int i = 0; i < 2; i++) {
      dice = List.generate(5, (_) => _random.nextInt(6) + 1);
    }

    state = dice;

    final rank = calculateHandRank(dice);

    ref.read(historyProvider.notifier).add(rank, player: PlayerType.ai);

    return rank;
  }
}
