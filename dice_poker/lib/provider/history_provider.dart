import 'package:dice_poker/model/dice_hand.dart';
import 'package:dice_poker/model/history_entry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyProvider = NotifierProvider<HistoryNotifier, List<HistoryEntry>>(
  HistoryNotifier.new,
);

class HistoryNotifier extends Notifier<List<HistoryEntry>> {
  @override
  List<HistoryEntry> build() {
    return [];
  }

  void add(HandRank hand, {PlayerType player = PlayerType.user}) {
    state = [...state, HistoryEntry(player: player, hand: hand)];
  }

  void reset() {
    state = [];
  }
}
