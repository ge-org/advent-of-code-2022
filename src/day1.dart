import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day1_sample");
  check(day1Part1(testInput), 24000);
  check(day1Part2(testInput), 45000);

  final input = await readInput("day1");
  print(day1Part1(input));
  print(day1Part2(input));
}

int day1Part1(String input) => caloriesPerElve(input).max;

int day1Part2(String input) =>
    caloriesPerElve(input).sorted((a, b) => b.compareTo(a)).take(3).sum;

Iterable<int> caloriesPerElve(String input) =>
    input.readParagraphs().readIntLines().map((calories) => calories.sum);
