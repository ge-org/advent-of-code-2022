import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day11_sample");
  check(part1(testInput), 10605);

  final input = await readInput("day11");
  print(part1(input));
}

int part1(String input) {
  final data = parse(input.readParagraphs());
  20.repeat(() {
    for (final monkey in data) {
      final itemsToPass = <int, List<int>>{};
      final itemsToRemove = [];
      monkey["items"].forEach((originalLevel) {
        monkey.update("inspections", (value) => (value as int) + 1);
        final newLevel =
            applyOperation(originalLevel, monkey["operation"]) ~/ 3;
        final nextMonkey = applyTest(newLevel, monkey["test"]);
        itemsToPass.putIfAbsent(nextMonkey, () => []);
        itemsToPass[nextMonkey]!.add(newLevel);
        itemsToRemove.add(originalLevel);
      });
      monkey["items"].removeWhere((element) => itemsToRemove.contains(element));
      itemsToPass.forEach((monkeyIndex, newItems) {
        data[monkeyIndex]["items"].addAll(newItems);
      });
    }
  });

  final topTwo = data
      .map((e) => e["inspections"])
      .sorted((lhs, rhs) => rhs.compareTo(lhs))
      .take(2)
      .toList();
  return topTwo[0] * topTwo[1];
}

List<Map<String, dynamic>> parse(List<String> input) => input.map((paragraph) {
      final data = paragraph.readLines();
      return {
        "items": data[1]
            .substringAfter(": ")!
            .replaceAll(",", "")
            .split(" ")
            .map((e) => int.parse(e))
            .toList(),
        "operation": data[2].substringAfter("= ")!.split(" ").skip(1).toList(),
        "test": {
          "divisor": int.parse(data[3].split(" ").last),
          "true": int.parse(data[4].split(" ").last),
          "false": int.parse(data[5].split(" ").last),
        },
        "inspections": 0,
      };
    }).toList();

int applyOperation(int original, List<String> ops) {
  switch (ops[0]) {
    case "*":
      return ops[1] == "old"
          ? original * original
          : original * int.parse(ops[1]);
    case "+":
      return ops[1] == "old"
          ? original + original
          : original + int.parse(ops[1]);
    default:
      return original;
  }
}

int applyTest(int level, Map<String, int> test) =>
    level % test["divisor"]! == 0 ? test["true"]! : test["false"]!;

extension Substrings on String {
  String? substringAfter(String delimiter) {
    final index = indexOf(delimiter);
    if (index == -1) return null;
    return substring(index + delimiter.length);
  }
}
