import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day7_sample");
  check(part1(testInput), 95437);

  final input = await readInput("day7");
  print(part1(input));
}

int part1(String input) {
  final data = input.readLines().fold(<String, dynamic>{
    "path": ["/"],
    "dirs": {"/": 0},
  }, (data, line) {
    updatePath(data["path"] as List<String>, line);
    addDir(data["dirs"], (data["path"] as List<String>).join("/"), line);
    addFile(data, line);
    return data;
  });
  return (data["dirs"] as Map<String, int>)
      .values
      .where((element) => element <= 100000)
      .sum;
}

String? getNewDirectory(String input) {
  final index = input.indexOf("\$ cd ");
  if (index == -1) return null;
  return input.substring(index + 5);
}

String? getDirectoryName(String input) {
  final index = input.indexOf("dir ");
  if (index == -1) return null;
  return input.substring(index + 4);
}

Map<String, dynamic>? getFile(String input) {
  final data = input.split(" ");
  if (data.length != 2) return null;
  final size = int.tryParse(data[0]);
  if (size == null) return null;
  return {"size": size, "name": data[1]};
}

void updatePath(List<String> path, String input) {
  final dir = getNewDirectory(input);
  if (dir == null) return;
  switch (dir) {
    case "/":
      path = ["/"];
      break;
    case "..":
      path.removeLast();
      break;
    default:
      path.add(dir);
      break;
  }
}

void addDir(Map<String, int> data, String fullPath, String input) {
  final dir = getDirectoryName(input);
  if (dir == null) return;
  data.putIfAbsent("$fullPath/$dir", () => 0);
}

void addFile(Map<String, dynamic> data, String input) {
  final file = getFile(input);
  if (file == null) return;
  final path = (data["path"] as List<String>).toList();
  while (path.isNotEmpty) {
    final cwd = path.join("/");
    path.removeLast();
    data["dirs"][cwd] = data["dirs"][cwd] + file["size"];
  }
}
