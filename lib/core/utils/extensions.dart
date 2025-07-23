import 'package:flutter/material.dart';
import 'constants.dart';

extension CardValueExtensions on int {
  CardValueColor get cardColor {
    if (this <= -1) return CardValueColor.darkBlue;
    if (this == 0) return CardValueColor.lightBlue;
    if (this <= 4) return CardValueColor.green;
    if (this <= 8) return CardValueColor.yellow;
    return CardValueColor.red;
  }

  Color get displayColor {
    switch (cardColor) {
      case CardValueColor.darkBlue:
        return const Color(0xFF1565C0);
      case CardValueColor.lightBlue:
        return const Color(0xFF42A5F5);
      case CardValueColor.green:
        return const Color(0xFF66BB6A);
      case CardValueColor.yellow:
        return const Color(0xFFFFCA28);
      case CardValueColor.red:
        return const Color(0xFFEF5350);
    }
  }
}

extension ListExtensions<T> on List<T> {
  List<T> shuffled() {
    final list = List<T>.from(this);
    list.shuffle();
    return list;
  }

  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}
