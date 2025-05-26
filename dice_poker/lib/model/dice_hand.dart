enum HandRank {
  fiveOfAKind,
  fourOfAKind,
  fullHouse,
  straight,
  threeOfAKind,
  twoPair,
  onePair,
  nothing,
}

extension HandRankName on HandRank {
  String get label {
    switch (this) {
      case HandRank.fiveOfAKind:
        return 'Five of a Kind';
      case HandRank.fourOfAKind:
        return 'Four of a Kind';
      case HandRank.fullHouse:
        return 'Full House';
      case HandRank.straight:
        return 'Straight';
      case HandRank.threeOfAKind:
        return 'Three of a Kind';
      case HandRank.twoPair:
        return 'Two Pair';
      case HandRank.onePair:
        return 'One Pair';
      case HandRank.nothing:
        return 'Nothing';
    }
  }
}

HandRank calculateHandRank(List<int> diceValues) {
  final counts = <int, int>{};

  for (var value in diceValues) {
    counts[value] = (counts[value] ?? 0) + 1;
  }

  final values = counts.values.toList()..sort((a, b) => b.compareTo(a));
  final unique = counts.keys.toList()..sort();

  if (values[0] == 5) return HandRank.fiveOfAKind;
  if (values[0] == 4) return HandRank.fourOfAKind;
  if (values[0] == 3 && values.length == 2) return HandRank.fullHouse;
  if (unique.length == 5 && (unique.last - unique.first == 4)) {
    return HandRank.straight;
  }
  if (values[0] == 3) return HandRank.threeOfAKind;
  if (values[0] == 2 && values[1] == 2) return HandRank.twoPair;
  if (values[0] == 2) return HandRank.onePair;

  return HandRank.nothing;
}
