import 'dart:math';

import 'support.dart';

void main() async {
  final testInput = await readInput("day9_sample");
  final testInput2 = await readInput("day9_sample2");
  check(getTailMovements(testInput, numberOfKnots: 2), 13);
  check(getTailMovements(testInput, numberOfKnots: 10), 1);
  check(getTailMovements(testInput2, numberOfKnots: 10), 36);

  final input = await readInput("day9");
  print(getTailMovements(input, numberOfKnots: 2));
  print(getTailMovements(input, numberOfKnots: 10));
}

int getTailMovements(String input, {required int numberOfKnots}) =>
    input.readLines().map((e) => e.split(" ")).fold(<String, dynamic>{
      "knots": List.generate(numberOfKnots, (_) => [0, 0]),
      "log": {
        "0x0",
      },
    }, (data, inp) {
      int.parse(inp[1]).repeat(() {
        final knots = data["knots"] as List<List<int>>;
        // move first knot of rope
        knots[0] = getHeadPosition(inp[0], knots[0]);
        // move each pair of knots by following the first knot
        for (var headIndex = 0; headIndex < knots.length; headIndex++) {
          knots.map((e) => knots.indexOf(e));
          final tailIndex =
              headIndex + 1 < knots.length ? headIndex + 1 : headIndex;
          knots[tailIndex] =
              getTailPosition(knots[headIndex], knots[tailIndex]);
        }
        data["log"].add(knots.last.join("x"));
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
