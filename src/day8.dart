import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day8_sample");
  check(part1(testInput), 21);
  check(part2(testInput), 8);

  final input = await readInput("day8");
  print(part1(input));
  print(part2(input));
}

int part1(String input) {
  final grid = input
      .readLines()
      .map((e) => e.split("").map(int.parse).toList())
      .toList();
  final height = grid.length;
  final width = grid.first.length;

  final res = <String>{};
  for (var row = 0; row < height; row++) {
    res.addAll(getVisibleTrees(grid[row], row, true));
  }
  for (var col = 0; col < width; col++) {
    final column = List.generate(height, (row) => grid[row][col]);
    res.addAll(getVisibleTrees(column, col, false));
  }
  return res.length;
}

int part2(String input) {
  final grid = input
      .readLines()
      .map((e) => e.split("").map(int.parse).toList())
      .toList();
  final height = grid.length;
  final width = grid.first.length;
  final scores = <int>[];
  for (var row = 0; row < height; row++) {
    for (var col = 0; col < width; col++) {
      final treeHeight = grid[row][col];
      final column = List.generate(height, (row) => grid[row][col]);
      final l =
          grid[row].sublist(0, col).reversed.getViewingDistance(treeHeight);
      final r = grid[row].sublist(col + 1).getViewingDistance(treeHeight);
      final t = column.sublist(0, row).reversed.getViewingDistance(treeHeight);
      final d = column.sublist(row + 1).getViewingDistance(treeHeight);
      scores.add(l * r * t * d);
    }
  }
  return scores.max;
}

Set<String> getVisibleTrees(List<int> row, int index, bool isHorizontal) {
  String getName(int a, int b) => isHorizontal ? "${a}x$b" : "${b}x$a";
  var visibleTreeCoordinates = <String>{};
  var maxLeft = -1;
  for (var i = 0; i < row.length; i++) {
    if (row[i] > maxLeft) {
      maxLeft = row[i];
      visibleTreeCoordinates.add(getName(index, i));
    }
  }
  var maxRight = -1;
  for (var i = row.length - 1; i >= 0; i--) {
    if (maxLeft == maxRight) break;
    if (row[i] > maxRight) {
      maxRight = row[i];
      visibleTreeCoordinates.add(getName(index, i));
    }
  }
  return visibleTreeCoordinates;
}

extension ViewingDistance on Iterable<int> {
  int getViewingDistance(int treeHeight) =>
      fold(<String, dynamic>{"prev": -1, "res": []}, (data, item) {
        if (data["prev"] < treeHeight) {
          data["res"].add(item);
          data["prev"] = item;
        }
        return data;
      })["res"]
          .length;
}
