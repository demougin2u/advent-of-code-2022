import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  File inputFile = File('./10/input.txt');
  List<Command> commands = inputFile.readAsStringSync().split('\n').map((line) => Command.fromString(line)).toList();

  print('---------- PART I ----------');
  print(partOne(commands.map((command) => command.clone()).toList()));
  print('---------- PART II ----------');
  print(partTwo(commands.map((command) => command.clone()).toList()));
}

int partOne(List<Command> commands) {
  final List<int> cycles = [20, 60, 100, 140, 180, 220];
  int x = 1;
  int res = 0;
  Command currentCommand = commands.first;
  int commandIndex = 1;
  for (int cycle = 1; cycle <= cycles.last; cycle++) {
    if (cycles.contains(cycle)) {
      res += cycle * x;
      //   print('($cycle) $x => $res');
    }

    x = currentCommand.executeCommand(x);
    if (currentCommand.isFinished) {
      currentCommand = commands.elementAt(commandIndex);
      commandIndex++;
    }
  }
  return res;
}

String partTwo(List<Command> commands) {
  final List<int> cycles = [40, 80, 120, 160, 200, 240];
  int x = 1;
  List<String> res = [];
  List<String> currentLine = [];
  Command? currentCommand = commands.first;
  int commandIndex = 1;
  for (int cycle = 1; cycle <= cycles.last; cycle++) {
    final int currentCRTIndex = currentLine.length;
    if ((x - currentCRTIndex).abs() <= 1) {
      currentLine.add('X');
    } else {
      currentLine.add('.');
    }

    if (cycles.contains(cycle)) {
      res.add(currentLine.join(''));
      currentLine = [];
    }

    if (currentCommand == null) continue;

    x = currentCommand.executeCommand(x);
    if (currentCommand.isFinished) {
      currentCommand = commands.length > commandIndex ? commands.elementAt(commandIndex) : null;
      commandIndex++;
    }
  }
  return res.join('\n');
}

class Command {
  int _duration;
  final int _value;

  Command(this._duration, this._value);

  factory Command.fromString(String line) {
    List<String> splittedLine = line.split(' ');
    switch (splittedLine[0]) {
      case 'noop':
        return Noop();
      case 'addx':
        return AddX(int.parse(splittedLine[1]));
    }

    throw Exception('Command ${splittedLine[0]} not found');
  }

  bool get isFinished => _duration == 0;

  int executeCommand(int x) {
    _duration--;
    if (!isFinished) {
      return x;
    }
    return x + _value;
  }

  Command clone() {
    return Command(_duration, _value);
  }
}

class Noop extends Command {
  Noop() : super(1, 0);
}

class AddX extends Command {
  AddX(int value) : super(2, value);
}
