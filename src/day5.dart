import 'package:collection/collection.dart';

import 'support.dart';

void main() async {
  final testInput = await readInput("day5_sample");
  check(part1(testInput, moveMultiple: false), "CMZ");
  check(part1(testInput, moveMultiple: true), "MCD");

  final input = await readInput("day5");
  print(part1(input, moveMultiple: false));
  print(part1(input, moveMultiple: true));
}

String part1(String input, {required bool moveMultiple}) {
  final stackAndCommands = input.readParagraphs();
  final stackInput = stackAndCommands[0].readLines();
  final stack = getStack(stackInput);
  final commandInput = stackAndCommands[1].readLines();
  final commands = getCommands(commandInput);
  return applyCommands(stack, commands, moveMultiple)
      .entries
      .toList()
      .sorted((lhs, rhs) => lhs.key.compareTo(rhs.key))
      .map((stackEntry) => stackEntry.value.first)
      .join();
}

Map<int, List<String>> getStack(List<String> stackInput) {
  final numberOfSlots = getNumberOfStacks(stackInput);
  return stackInput.reversed.skip(1).fold(<int, List<String>>{},
      (stacks, line) {
    getStackEntries(line.padRight(numberOfSlots * 4))
        .mapIndexed((index, stackEntry) {
      if (stackEntry != null) {
        return stacks.putIfAbsent(index + 1, () => []).add(stackEntry);
      }
    }).toList();
    return stacks;
  }).map((key, value) => MapEntry(key, value.reversed.toList()));
}

int getNumberOfStacks(List<String> stack) => stack.last
    .split('')
    .where((element) => int.tryParse(element) != null)
    .length;

List<String?> getStackEntries(String stackLine) => RegExp(r".{4}")
    .allMatches(stackLine)
    .map((match) => getCrateName(match.group(0)!))
    .toList();

String? getCrateName(String stackItem) => RegExp(r"\w").stringMatch(stackItem);

List<List<int>> getCommands(List<String> commandInput) => commandInput
    .map((line) => RegExp(r"\d+")
        .allMatches(line)
        .map((e) => int.parse(e.group(0)!))
        .toList())
    .toList();

Map<int, List<String>> applyCommands(
  Map<int, List<String>> stack,
  List<List<int>> commands,
  bool moveMultiple,
) =>
    commands.fold(stack, (stack, command) {
      final amount = command[0];
      final itemsToMove = stack[command[1]]!.sublist(0, amount);
      stack[command[1]]!.removeRange(0, amount);
      stack[command[2]]!
          .insertAll(0, moveMultiple ? itemsToMove : itemsToMove.reversed);
      return stack;
    });
