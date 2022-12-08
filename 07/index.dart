import 'dart:io' as io;

void main(List<String> args) {
  io.File inputFile = io.File('./07/input.txt');
  List<String> textInput = inputFile
      .readAsStringSync()
      .split('\$')
      .map(
        (e) => e.trim(),
      )
      .where((element) => element != '')
      .toList();

  final Directory rootDir = Directory(name: '/');
  hydrateDirFromInput(rootDir, textInput);

  print('---------- PART I ----------');
  print(partOne(rootDir));
  print('---------- PART II ----------');
  print(partTwo(rootDir, totalSize: 70000000, minSizeRequired: 30000000));
}

void hydrateDirFromInput(Directory rootDir, List<String> input) {
  Directory currentDir = rootDir;
  input.forEach((commandString) {
    currentDir = Command.fromString(commandString)
        .execute(currentDir: currentDir, rootDir: rootDir);
  });
}

abstract class Command {
  final String input;

  Command(this.input);

  factory Command.fromString(String commandString) {
    if (commandString.startsWith('cd')) {
      return ChangeDirectoryCommand(commandString);
    }
    if (commandString.startsWith('ls')) {
      return ListCommand(commandString);
    }
    throw UnknownCommandException(commandString);
  }

  /// execute command and return current directory
  Directory execute({
    required Directory rootDir,
    required Directory currentDir,
  });
}

class UnknownCommandException implements Exception {
  final String? commandName;

  UnknownCommandException([this.commandName]);

  @override
  String toString() {
    String result = 'UnknownCommandException';
    if (commandName is String) return '$result: $commandName';
    return result;
  }
}

class ChangeDirectoryCommand extends Command {
  ChangeDirectoryCommand(String input) : super(input);

  @override
  Directory execute({
    required Directory rootDir,
    required Directory currentDir,
  }) {
    final String destination = input.split(' ')[1];

    if (destination == rootDir.name) return rootDir;
    if (destination == Directory.parentIdentifier)
      return currentDir.parent ?? rootDir;

    return currentDir.find(destination);
  }
}

class ListCommand extends Command {
  ListCommand(String input) : super(input);

  @override
  Directory execute({
    required Directory rootDir,
    required Directory currentDir,
  }) {
    final List<String> listOutput = input.split('\n')..removeAt(0);
    listOutput.forEach((outputString) {
      final Element newElement =
          Element.fromString(outputString, parent: currentDir);
      currentDir.addChild(newElement);
    });

    return currentDir;
  }
}

abstract class Element {
  final String name;

  Element(this.name);

  int get size;

  factory Element.fromString(String line, {required Directory parent}) {
    final List<String> lineSplitted = line.split(' ');
    if (lineSplitted[0] == Directory.dirIdentifier)
      return Directory(name: lineSplitted[1], parent: parent);

    return File(name: lineSplitted[1], size: int.parse(lineSplitted[0]));
  }
}

class Directory extends Element {
  static String parentIdentifier = '..';
  static String dirIdentifier = 'dir';

  final Directory? parent;
  final List<Element> _children = [];

  Directory({required String name, this.parent}) : super(name);

  int get size => _children.fold(0, (acc, child) => acc + child.size);
  List<Directory> get allDirectories =>
      _children.whereType<Directory>().toList();

  void addChild(Element child) {
    _children.add(child);
  }

  Directory find(childName) => _children.firstWhere(
      (child) => child is Directory && child.name == childName) as Directory;
}

class File extends Element {
  final int size;

  File({required String name, required this.size}) : super(name);
}

List<T> flatten<T>(Iterable<Iterable<T>> list) =>
    [for (var sublist in list) ...sublist];

List<Directory> getAllDirectories(Directory rootDir) {
  return flatten<Directory>([
    [rootDir],
    ...rootDir.allDirectories.map((directory) => getAllDirectories(directory))
  ]);
}

int partOne(Directory rootDir) {
  final List<Directory> allDir = getAllDirectories(rootDir);
  return allDir.fold(0, (acc, dir) {
    final int size = dir.size;
    if (size > 100000) return acc;
    return acc + size;
  });
}

int partTwo(Directory rootDir,
    {required int totalSize, required int minSizeRequired}) {
  final List<Directory> allDir = getAllDirectories(rootDir);
  final int freeSpaceToAdd = minSizeRequired - (totalSize - rootDir.size);
  return allDir.fold(rootDir.size, (previousValue, currentDir) {
    if (currentDir.size >= freeSpaceToAdd && currentDir.size < previousValue)
      return currentDir.size;
    return previousValue;
  });
}
