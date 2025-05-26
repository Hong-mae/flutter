import 'dart:math';

import 'package:dice_poker/model/dice_hand.dart';
import 'package:dice_poker/model/history_entry.dart';
import 'package:dice_poker/provider/history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final diceProvider = NotifierProvider<DiceNotifier, DiceState>(
  DiceNotifier.new,
);

class Dice {
  final int value;
  final bool isHeld;

  Dice({required this.value, this.isHeld = false});

  Dice copyWith({int? value, bool? isHeld}) {
    return Dice(value: value ?? this.value, isHeld: isHeld ?? this.isHeld);
  }
}

class DiceState {
  final List<Dice> diceList;
  final int rollCount;

  DiceState({required this.diceList, required this.rollCount});

  DiceState copyWith({List<Dice>? diceList, int? rollCount}) {
    return DiceState(
      diceList: diceList ?? this.diceList,
      rollCount: rollCount ?? this.rollCount,
    );
  }
}

class DiceNotifier extends Notifier<DiceState> {
  final int maxRolls = 3;
  final int diceCount = 5;

  @override
  DiceState build() {
    return DiceState(
      diceList: List.generate(
        diceCount,
        (_) => Dice(value: Random().nextInt(6) + 1),
      ),
      rollCount: 0,
    );
  }

  void roll() {
    if (state.rollCount >= maxRolls) return;

    final updateDice = [
      for (final dice in state.diceList)
        dice.isHeld ? dice : dice.copyWith(value: Random().nextInt(6) + 1),
    ];

    state = state.copyWith(
      diceList: updateDice,
      rollCount: state.rollCount + 1,
    );
  }

  void toggleHold(int index) {
    final updated = [
      for (int i = 0; i < state.diceList.length; i++)
        i == index
            ? state.diceList[i].copyWith(isHeld: !state.diceList[i].isHeld)
            : state.diceList[i],
    ];

    state = state.copyWith(diceList: updated);
  }

  void resetTurn() {
    state = DiceState(
      diceList: List.generate(5, (_) => Dice(value: Random().nextInt(6) + 1)),
      rollCount: 0,
    );
  }

  void endTurn(WidgetRef ref) {
    final hand = calculateHandRank(state.diceList.map((e) => e.value).toList());

    ref.read(historyProvider.notifier).add(hand, player: PlayerType.user);

    resetTurn();
  }
}
