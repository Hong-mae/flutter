import 'package:dice_poker/model/dice_hand.dart';
import 'package:dice_poker/model/history_entry.dart';
import 'package:dice_poker/provider/ai_provider.dart';
import 'package:dice_poker/provider/dice_provider.dart';
import 'package:dice_poker/provider/history_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:dice_poker/widget/dice_face.dart';

class DiceScreen extends ConsumerWidget {
  const DiceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diceState = ref.watch(diceProvider);
    final history = ref.watch(historyProvider);

    final notifier = ref.read(diceProvider.notifier);

    final diceList = diceState.diceList;
    final rollCount = diceState.rollCount;

    final handRank = calculateHandRank(diceList.map((e) => e.value).toList());

    return Scaffold(
      appBar: AppBar(title: const Text('🎲 Dice Poker')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text('굴리기 횟수: $rollCount / 3', style: const TextStyle(fontSize: 18)),
          Text(
            '족보: ${handRank.label}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(diceList.length, (i) {
              final dice = diceList[i];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: DiceFace(
                  value: dice.value,
                  isHeld: dice.isHeld,
                  onTap: () => notifier.toggleHold(i),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: rollCount < 3 ? notifier.roll : null,
            child: const Text('주사위 굴리기'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => notifier.endTurn(ref), // ✅ 히스토리 기록 포함
            child: const Text('턴 종료'),
          ),
          const Divider(height: 32, thickness: 2),
          const Text('📜 히스토리'),
          ElevatedButton(
            onPressed: () {
              // 1. AI 턴 실행
              final aiRank = ref.read(aiProvider.notifier).playTurn();

              // 2. 히스토리에 AI 결과 추가
              ref.read(historyProvider.notifier).add(aiRank);

              // 3. 사용자 턴 초기화 (이전처럼)
              notifier.resetTurn();
            },
            child: const Text('AI 턴 진행'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final entry = history[index];
                final prefix = entry.player == PlayerType.user ? '👤' : '🤖';

                return ListTile(
                  title: Text('$prefix 턴 ${index + 1}: ${entry.hand.label}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
