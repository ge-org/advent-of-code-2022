import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day10_sample");
  check(part1(testInput), 13140);

  final input = await readInput("day10");
  print(part1(input));
}

int part1(String input) {
  final data = input.readLines().map(getOperationValue).fold(<String, dynamic>{
    "cycle": 1,
    "x": 1,
    "cycles": {1: 1},
  }, (data, op) {
    data.update("cycle", (c) => c + 1);
    data["cycles"].putIfAbsent(data["cycle"], () => data["x"] as int);
    if (op != null) {
      data.update("x", (x) => x + op);
      data.update("cycle", (c) => c + 1);
      data["cycles"][data["cycle"]] = data["x"];
    }
    data["cycles"][data["cycle"]] = data["x"];
    return data;
  });
  return [20, 60, 100, 140, 180, 220]
      .map((cycle) => (data["cycles"][cycle] * cycle) as int)
      .sum;
}

int? getOperationValue(String operation) {
  if (operation == "noop") return null;
  return int.parse(operation.split(" ")[1]);
}
