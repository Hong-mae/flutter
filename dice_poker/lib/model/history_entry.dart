// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dice_poker/model/dice_hand.dart';
import 'package:dice_poker/provider/history_provider.dart';

enum PlayerType { user, ai }

class HistoryEntry {
  final PlayerType player;
  final HandRank hand;

  HistoryEntry({required this.player, required this.hand});
}
