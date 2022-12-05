import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day3_sample");
  check(part1(testInput), 157);
  check(part2(testInput), 70);

  final input = await readInput("day3");
  print(part1(input));
  print(part2(input));
}

int part1(String input) => input
    .readLines()
    .map((line) {
      var half = line.length ~/ 2;
      final compartmentA = line.substring(0, half).split('');
      final compartmentB = line.substring(half).split('');
      return getCommonElements([compartmentA, compartmentB]);
    })
    .map((elements) => elements.map((e) => getPriority(e)).sum)
    .sum;

int part2(String input) => input
    .readLines()
    .slices(3)
    .map((group) => group.map((e) => e.split('')))
    .map(getCommonElements)
    .flattened
    .map((e) => getPriority(e))
    .sum;

Set<dynamic> getCommonElements(Iterable<Iterable<dynamic>> collections) =>
    collections.fold(
        collections.first.toSet(),
        (commonElements, current) =>
            commonElements.intersection(current.toSet()));

const priorities = "abcdefghijklmnopqrstyvwxyzABCDEFGHIJKLMNOPQRSTYVWXYZ";

int getPriority(String item) => priorities.indexOf(item) + 1;
