import 'dart:collection';

import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day12_sample");
  check(part1(testInput), 31);
  check(part2(testInput), 29);

  final input = await readInput("day12");
  print(part1(input));
  print(part2(input));
}

int part1(String input) {
  final data = getData(input);
  return getShortestPath(data, (node) => node["name"] == data["source"]);
}

int part2(String input) {
  final data = getData(input);
  return getShortestPath(data, (node) => node["w"] == 0);
}

int getShortestPath(Map data, bool Function(Map node) isDestination) {
  final seen = <String>[];
  final queue = Queue<dynamic>();

  /* we begin searching from the end. this makes part two easier since we do
     not have to iterate all 'a' spots. instead we can directly find the shortest
     path from the end to the first 'a'. */
  queue.addFirst({"node": data["graph"][data["destination"]], "d": 0});
  while (queue.isNotEmpty) {
    final step = queue.removeFirst();
    if (isDestination(step["node"])) {
      return step["d"];
    }

    getNeighbors(step["node"], data)
        .where((neighbor) => !seen.contains(neighbor["name"]))
        .where((neighbor) => neighbor["w"] >= step["node"]["w"] - 1)
        .forEach((neighbor) {
      queue.addLast({"node": neighbor, "d": step["d"] + 1});
      seen.add(neighbor["name"]);
    });
  }
  throw Exception("could not find shortest path :(");
}

Map getData(String input) {
  var lines = input.readLines();
  final data = <dynamic, dynamic>{
    "source": "",
    "destination": "",
    "width": lines[0].length,
    "height": lines.length,
    "graph": {},
  };

  lines.map((e) => e.split("").toList()).toList().forEachIndexed((row, line) {
    line.forEachIndexed((col, char) {
      if (char == "S") data["source"] = "${row}x$col";
      if (char == "E") data["destination"] = "${row}x$col";
      data["graph"].putIfAbsent(
          "${row}x$col",
          () => {
                "name": "${row}x$col",
                "r": row,
                "c": col,
                "w": getWeight(char)
              });
    });
  });
  return data;
}

List getNeighbors(Map node, Map data) {
  final neighbors = [];
  final row = node["r"];
  final col = node["c"];
  for (final coords in [
    [row + 1, col],
    [row, col + 1],
    [row - 1, col],
    [row, col - 1],
  ]) {
    final x = coords[0];
    final y = coords[1];
    if (x >= 0 && x < data["height"] && y >= 0 && y < data["width"]) {
      neighbors.add(data["graph"]["${x}x$y"]);
    }
  }
  return neighbors;
}

const heights = "abcdefghijklmnopqrstuvwxyz";

int getWeight(String height) {
  if (height == "S") return 0;
  if (height == "E") return 25;
  return heights.indexOf(height);
}
