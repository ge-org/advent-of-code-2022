import 'dart:math';

import 'support.dart';

void main() async {
  final testInput = await readInput("day9_sample");
  check(part1(testInput), 13);

  final input = await readInput("day9");
  print(part1(input));
}

int part1(String input) =>
    input.readLines().map((e) => e.split(" ")).fold(<String, dynamic>{
      "h": [0, 0],
      "t": [0, 0],
      "log": {
        "0x0",
      },
    }, (data, inp) {
      var command = inp[0];
      int.parse(inp[1]).repeat(() {
        data["h"] = getHeadPosition(command, data["h"]);
        data["t"] = getTailPosition(data["h"], data["t"]);
        data["log"].add(data["t"].join("x"));
      });
      return data;
    })["log"].length;

List<int> getHeadPosition(String command, List<int> head) {
  final delta = getMoveDelta(command);
  return [head[0] + delta[0], head[1] + delta[1]];
}

List<int> getTailPosition(List<int> head, List<int> tail) {
  final headTailDelta = [head[0] - tail[0], head[1] - tail[1]];
  // tail needs to move because distance is too big
  if (getChebyshevDistance(headTailDelta) > 1) {
    // coerce to make sure tail only moves one step
    final delta = [
      headTailDelta[0].coerceIn(-1, 1),
      headTailDelta[1].coerceIn(-1, 1),
    ];
    return [tail[0] + delta[0], tail[1] + delta[1]];
  }
  // tail is still close enough
  else {
    return tail;
  }
}

// tail moves like a king in chess
int getChebyshevDistance(List<int> delta) => max(
      delta[0].abs(),
      delta[1].abs(),
    );

List<int> getMoveDelta(String command) {
  switch (command) {
    case "R":
      return [1, 0];
    case "L":
      return [-1, 0];
    case "U":
      return [0, 1];
    case "D":
      return [0, -1];
    default:
      return [0, 0];
  }
}

extension Loop on int {
  void repeat(Function f) {
    for (var i = 0; i < this; i++) {
      f();
    }
  }
}

extension Range on int {
  int coerceIn(int min, int max) {
    if (this >= min && this <= max) {
      return this;
    } else if (this < min) {
      return min;
    } else {
      return max;
    }
  }
}
