import 'dart:convert';
import 'dart:io';

/// Returns the puzzle input contained in the file [name].
Future<String> readInput(String name) async =>
    File("./inputs/$name.txt").readAsString();

/// Functions to parse a string into separate lines.
extension ParseLines on String {
  /// Splits a string into parts in places where two line breaks occur.
  List<String> readParagraphs() => split(RegExp(r'\n\n'));

  /// Splits a string into parts where a line break occurs.
  List<String> readLines() => LineSplitter().convert(this);
}

/// Functions to parse a collection of strings into separate lines.
extension ParseLinesCollection on List<String> {
  /// Splits a string into parts where a line break occurs and returns the lines as int value.
  List<List<int>> readIntLines() => map((line) =>
      LineSplitter().convert(line).map((e) => int.parse(e)).toList()).toList();
}

/// Throws an exception if [actual] does not equal [expected].
void check(dynamic actual, dynamic expected) {
  if (actual != expected) {
    throw Exception("Did expect $expected but was $actual");
  }
}

extension Loop on int {
  /// Repeats [f] [this] many times.
  void repeat(Function f) {
    for (var i = 0; i < this; i++) {
      f();
    }
  }
}

extension Aggregate on List<int> {
  int multiply() {
    if (length == 0) return 0;
    if (length == 1) return first;
    return fold(1, (result, element) => result * element);
  }
}
