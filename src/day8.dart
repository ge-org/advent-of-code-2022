import 'support.dart';

void main() async {
  final testInput = await readInput("day8_sample");
  check(part1(testInput), 21);

  final input = await readInput("day8");
  print(part1(input));
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
