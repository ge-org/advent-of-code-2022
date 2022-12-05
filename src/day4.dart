import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day4_sample");
  check(part1(testInput), 2);

  final input = await readInput("day4");
  print(part1(input));
}

int part1(String input) => input
        .readLines()
        .map((line) => line.split(',').map(
            (sectionRange) => sectionRange.split('-').map((e) => int.parse(e))))
        .flattened
        .slices(2)
        .where((pairs) {
      final pairA = pairs[0].toList();
      final pairB = pairs[1].toList();
      var aInB = pairA[0] >= pairB[0] &&
          pairA[0] <= pairB[1] &&
          pairA[1] >= pairB[0] &&
          pairA[1] <= pairB[1];
      var bInA = pairB[0] >= pairA[0] &&
          pairB[0] <= pairA[1] &&
          pairB[1] >= pairA[0] &&
          pairB[1] <= pairA[1];
      if (aInB || bInA) {
        return true;
      } else {
        return false;
      }
    }).length;
