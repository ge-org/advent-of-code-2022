import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day2_sample");
  check(part1(testInput), 15);
  check(part2(testInput), 12);

  final input = await readInput("day2");
  print(part1(input));
  print(part2(input));
}

int part1(String input) => input
    .readLines()
    .map((line) => line.split(r' ').map((symbol) => toShape(symbol)).toList())
    .map((shapes) => getShapePoints(shapes[1]) + getMatchScore(shapes))
    .sum;

int part2(String input) => input
    .readLines()
    .map((line) => line.split(r' '))
    .map((symbols) =>
        [toShape(symbols[0]), toRequiredShape(toShape(symbols[0]), symbols[1])])
    .map((shapes) => getShapePoints(shapes[1]) + getMatchScore(shapes))
    .sum;

int getMatchScore(List<String> shapes) {
  final playerA = shapes[0];
  final playerB = shapes[1];
  if (playerA == playerB) return 3;
  if (playerA == ROCK && playerB == PAPER) return 6;
  if (playerA == PAPER && playerB == SCISSORS) return 6;
  if (playerA == SCISSORS && playerB == ROCK) return 6;
  return 0;
}

const ROCK = 'rock';
const PAPER = 'paper';
const SCISSORS = 'scissors';

String toShape(String symbol) => {
      'A': ROCK,
      'B': PAPER,
      'C': SCISSORS,
      'X': ROCK,
      'Y': PAPER,
      'Z': SCISSORS,
    }[symbol]!;

String toRequiredShape(String opponentShape, String requirement) => {
      'X': {ROCK: SCISSORS, PAPER: ROCK, SCISSORS: PAPER},
      'Y': {ROCK: ROCK, PAPER: PAPER, SCISSORS: SCISSORS},
      'Z': {ROCK: PAPER, PAPER: SCISSORS, SCISSORS: ROCK},
    }[requirement]![opponentShape]!;

int getShapePoints(String shape) =>
    {
      ROCK: 1,
      PAPER: 2,
      SCISSORS: 3,
    }[shape] ??
    0;
