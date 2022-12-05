import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day4_sample");
  check(part1(testInput), 2);
  check(part2(testInput), 4);

  final input = await readInput("day4");
  print(part1(input));
  print(part2(input));
}

int part1(String input) => getPairs(input).where((pairs) {
      final pairA = pairs[0].toList();
      final pairB = pairs[1].toList();
      return oneContainedInOther(pairA, pairB);
    }).length;

int part2(String input) => getPairs(input).where((pairs) {
      final pairA = pairs[0].toList();
      final pairB = pairs[1].toList();
      return !oneOverlapsOther(pairA, pairB);
    }).length;

Iterable<List<Iterable<int>>> getPairs(String input) => input
    .readLines()
    .map((line) => line.split(',').map(
        (sectionRange) => sectionRange.split('-').map((e) => int.parse(e))))
    .flattened
    .slices(2);

bool oneContainedInOther(List<int> pairA, List<int> pairB) =>
    pairA[0] >= pairB[0] && pairA[1] <= pairB[1] ||
    pairB[0] >= pairA[0] && pairB[1] <= pairA[1];

bool oneOverlapsOther(List<int> pairA, List<int> pairB) =>
    pairA[1] < pairB[0] ||
    pairA[0] > pairB[1] ||
    pairB[1] < pairA[0] ||
    pairB[0] > pairA[1];
