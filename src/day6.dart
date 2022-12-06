import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = (await readInput("day6_sample")).readLines();
  ({0: 7, 1: 5, 2: 6, 3: 10, 4: 11}).forEach((index, solution) {
    check(findMarker(testInput[index], markerLength: 4), solution);
  });
  ({0: 19, 1: 23, 2: 23, 3: 29, 4: 26}).forEach((index, solution) {
    check(findMarker(testInput[index], markerLength: 14), solution);
  });

  final input = await readInput("day6");
  print(findMarker(input, markerLength: 4));
  print(findMarker(input, markerLength: 14));
}

int findMarker(String input, {required int markerLength}) =>
    input.split('').foldIndexed(<String, dynamic>{
      "marker": [],
      "index": 0,
    }, (index, data, currentChar) {
      if (data["marker"]!.toSet().toList().length != markerLength) {
        final markers = add(data["marker"]!, currentChar, markerLength);
        data["marker"] = markers;
        data["index"] = index;
      }
      return data;
    })["index"] +
    1;

List<dynamic> add(List<dynamic> collection, dynamic element, int maxSize) {
  if (collection.length >= maxSize) {
    return collection
      ..removeAt(0)
      ..add(element);
  } else {
    return collection..add(element);
  }
}
