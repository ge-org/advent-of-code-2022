import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day13_sample");
  check(part1(testInput), 13);

  final input = await readInput("day13");
  print(part1(input));
}

int part1(String input) => getPackets(input).mapIndexed((index, packets) {
      final packetA = packets[0];
      final packetB = packets[1];
      var correct = isCorrect(packetA, packetB);
      return correct ? index + 1 : 0;
    }).sum;

List makePairs(List packetA, List packetB) {
  final pairs = [];
  for (var i = 0; i < max(packetA.length, packetB.length); i++) {
    final lhs = packetA.length > i ? packetA[i] : null;
    final rhs = packetB.length > i ? packetB[i] : null;
    pairs.add([lhs, rhs]);
  }
  return pairs;
}

bool isCorrect(List packetA, List packetB) {
  final queue = [];
  makePairs(packetA, packetB).reversed.forEach((element) {
    queue.insert(0, element);
  });
  while (queue.isNotEmpty) {
    final both = queue.removeAt(0);
    final lhs = both[0];
    final rhs = both[1];

    if (rhs == null && lhs != null) return false;
    if (rhs != null && lhs == null) return true;
    if (lhs is int && rhs is int && lhs > rhs) return false;
    if (lhs is int && rhs is int && lhs < rhs) return true;
    if (lhs is int && rhs is int && lhs == rhs) continue;

    if (lhs is List && rhs is List) {
      makePairs(lhs, rhs).reversed.forEach((element) {
        queue.insert(0, element);
      });
    }

    if (lhs is int && rhs is List) {
      queue.insert(0, [
        [lhs],
        rhs
      ]);
    }

    if (lhs is List && rhs is int) {
      queue.insert(0, [
        lhs,
        [rhs]
      ]);
    }
  }
  throw Exception("Could not validate packets");
}

List getPackets(String input) {
  final data = [];
  input.readParagraphs().forEachIndexed((paragraphIndex, paragraph) {
    data.insert(paragraphIndex, []);
    paragraph.readLines().forEach((line) {
      data[paragraphIndex].add(jsonDecode(line));
    });
  });
  return data;
}
