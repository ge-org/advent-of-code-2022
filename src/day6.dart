import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = (await readInput("day6_sample")).readLines();
  ({0: 7, 1: 5, 2: 6, 3: 10, 4: 11}).forEach((index, solution) {
    check(part1(testInput[index]), solution);
  });

  final input = await readInput("day6");
  print(part1(input));
}

int part1(String input) =>
    input.split('').foldIndexed(<String, dynamic>{
      "marker": [],
      "index": 0,
    }, (index, data, currentChar) {
      if (data["marker"]!.toSet().toList().length != 4) {
        final markers = add(data["marker"]!, currentChar, maxSize: 4);
        data["marker"] = markers;
        data["index"] = index;
      }
      return data;
    })["index"] +
    1;

List<dynamic> add(List<dynamic> collection, dynamic element,
    {required int maxSize}) {
  if (collection.length >= maxSize) {
    return collection
      ..removeAt(0)
      ..add(element);
  } else {
    return collection..add(element);
  }
}
