import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day1_sample");
  check(day1Part1(testInput), 24000);

  final input = await readInput("day1");
  print(day1Part1(input));
}

int day1Part1(String input) => caloriesPerElve(input).max;

Iterable<int> caloriesPerElve(String input) =>
    input.readParagraphs().readIntLines().map((calories) => calories.sum);
