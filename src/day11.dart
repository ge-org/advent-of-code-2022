import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day11_sample");
  check(part1(testInput), 10605);
  check(part2(testInput), 2713310158);

  final input = await readInput("day11");
  print(part1(input));
  print(part2(input));
}

int part1(String input) {
  final data = parse(input.readParagraphs());
  return getMonkeyBusiness(data, rounds: 20, shrink: (value) => value ~/ 3);
}

int part2(String input) {
  final data = parse(input.readParagraphs());
  /* the trick is to calculate the common multiple and then mod every level
     by it to prevent overflowing 64bit ints. */
  final commonMultiple = data
      .map((monkey) => monkey["test"]["divisor"] as int)
      .toList()
      .multiply();
  return getMonkeyBusiness(data,
      rounds: 10000, shrink: (value) => value % commonMultiple);
}

int getMonkeyBusiness(List<Map<String, dynamic>> data,
    {required int rounds, required int Function(int) shrink}) {
  rounds.repeat(() {
    for (final monkey in data) {
      final itemsToPass = <int, List<int>>{};
      final itemsToRemove = [];
      monkey["items"].forEach((originalLevel) {
        monkey.update("inspections", (value) => (value as int) + 1);
        final newLevel =
            shrink(applyOperation(originalLevel, monkey["operation"]));
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

  return data
      .map((e) => e["inspections"] as int)
      .sorted((lhs, rhs) => rhs.compareTo(lhs))
      .take(2)
      .toList()
      .multiply();
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
