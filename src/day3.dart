import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day3_sample");
  check(part1(testInput), 157);

  final input = await readInput("day3");
  print(part1(input));
}

int part1(String input) => input
    .readLines()
    .map((line) {
      var half = line.length ~/ 2;
      final compartmentA = line.substring(0, half).split('').toSet();
      final compartmentB = line.substring(half).split('').toSet();
      return compartmentA.intersection(compartmentB);
    })
    .map((elements) => elements.map((e) => getPriority(e)).sum)
    .sum;

const priorities = "abcdefghijklmnopqrstyvwxyzABCDEFGHIJKLMNOPQRSTYVWXYZ";

int getPriority(String item) => priorities.indexOf(item) + 1;
