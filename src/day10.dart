import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final part2Solution = r"""
##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....""";

  final testInput = await readInput("day10_sample");
  check(part1(testInput), 13140);
  check(part2(testInput), part2Solution);

  final input = await readInput("day10");
  print(part1(input));
  print(part2(input));
}

int part1(String input) {
  final data = executeProgram(input);
  return [20, 60, 100, 140, 180, 220]
      .map((cycle) => (data["cycles"][cycle] * cycle) as int)
      .sum;
}

String part2(String input) => executeProgram(input)["crt"]
    .asMap()
    .entries
    .map((e) => (e.key + 1) % 40 == 0 ? "${e.value}\n" : e.value)
    .join()
    .trim();

Map<String, dynamic> executeProgram(String input) =>
    input.readLines().map(getOperationValue).fold(<String, dynamic>{
      "cycle": 1,
      "x": 1,
      "cycles": {1: 1},
      "crt": [],
    }, (data, op) {
      if (op != null) {
        updateCrt(data);
        data.update("cycle", (c) => c + 1);
        data["cycles"].putIfAbsent(data["cycle"], () => data["x"] as int);
        updateCrt(data);
        data.update("x", (x) => x + op);
        data["cycles"].putIfAbsent(data["cycle"], () => data["x"] as int);
        data.update("cycle", (c) => c + 1);
        data["cycles"].putIfAbsent(data["cycle"], () => data["x"] as int);
      } else {
        updateCrt(data);
        data.update("cycle", (c) => c + 1);
        data["cycles"].putIfAbsent(data["cycle"], () => data["x"] as int);
      }
      return data;
    });

void updateCrt(Map<String, dynamic> data) {
  var crtPos = (data["cycle"] - 1) % 40;
  var x = data["x"];
  if (crtPos == x - 1 || crtPos == x || crtPos == x + 1) {
    data["crt"].add("#");
  } else {
    data["crt"].add(".");
  }
}

int? getOperationValue(String operation) {
  if (operation == "noop") return null;
  return int.parse(operation.split(" ")[1]);
}
