import 'dart:io';

void main(List<String> args) {
  File inputFile = File('./11/input.txt');
  List<Monkey> monkeys = inputFile.readAsStringSync().split('\n\n').map((e) => Monkey.fromString(e)).toList();

  print('---------- PART I ----------');
  print(
    partOne(
      monkeys.map((e) => e.clone()).toList(),
    ),
  );
  print('---------- PART II ----------');
  print(partTwo(monkeys));
}

int partOne(List<Monkey> monkeys) {
  for (int i = 0; i < 20; i++) {
    monkeys.forEach((monkey) {
      monkey.executeRound(monkeys);
    });
  }

  int max1 = 0;
  int max2 = 0;

  monkeys.forEach((monkey) {
    if (monkey.numberOfInspections > max1) {
      max2 = max1;
      max1 = monkey.numberOfInspections;
      return;
    }
    if (monkey.numberOfInspections > max2) {
      max2 = monkey.numberOfInspections;
    }
  });

  return max1 * max2;
}

int partTwo(List<Monkey> monkeys) {
  return monkeys.length;
}

class Monkey {
  final List<int> items;
  final int id;
  final int Function(int) getWorryLevel;
  final int Function(int) getMonkeyId;
  int _numberOfInspections;

  Monkey._(this.items, this.id, this.getWorryLevel, this.getMonkeyId) : _numberOfInspections = 0;

  void executeRound(List<Monkey> monkeys) {
    items.forEach((itemWorryLevel) {
      _numberOfInspections++;
      int newWorryLevel = getWorryLevel(itemWorryLevel);
      int giveToMonkeyId = getMonkeyId(newWorryLevel);
      monkeys[giveToMonkeyId].items.add(newWorryLevel);
    });
    items.clear();
  }

  int get numberOfInspections => _numberOfInspections;

  @override
  String toString() {
    return 'Monkey $id: ${items.join(', ')}';
  }

  Monkey clone() {
    return Monkey._(items, id, getWorryLevel, getMonkeyId);
  }

  factory Monkey.fromString(String input) {
    List<String> inputLines = input.split('\n');
    int id = _getIdFromStringLine(inputLines[0]);
    List<int> items = _getItemsFromStringLine(inputLines[1]);
    int Function(int) operation = _getWorryLevelFunctionFromStringLine(inputLines[2]);
    int Function(int) getMonkeyId = _getMonkeyIdFunctionFromStringLines(inputLines.getRange(3, 6).join(' '));

    return Monkey._(items, id, operation, getMonkeyId);
  }

  static int _getIdFromStringLine(String inputLine) {
    RegExpMatch? match = RegExp(r'Monkey (\d+):').firstMatch(inputLine);
    String? id = match?.group(1);
    if (id == null) throw Exception('monkey id is not found in `$inputLine`');

    return int.parse(id);
  }

  static List<int> _getItemsFromStringLine(String inputLine) {
    RegExpMatch? match = RegExp(r'Starting items: ((\d+, )*\d+)').firstMatch(inputLine);
    String? itemsString = match?.group(1);
    if (itemsString == null) return [];
    return itemsString.split(', ').map((e) => int.parse(e)).toList();
  }

  static int Function(int) _getWorryLevelFunctionFromStringLine(String inputLine) {
    List<String> operationString = inputLine.split(' ').getRange(5, 8).toList();
    String leftString = operationString[0];
    String sign = operationString[1];
    String rightString = operationString[2];

    return (int worryLevel) {
      int left = leftString == 'old' ? worryLevel : int.parse(leftString);
      int right = rightString == 'old' ? worryLevel : int.parse(rightString);
      int res = 0;
      switch (sign) {
        case '+':
          res = left + right;
          break;
        case '-':
          res = left - right;
          break;
        case '*':
          res = left * right;
          break;
        default:
          throw Exception('sign not found $sign');
      }

      return (res / 3).floor();
    };
  }

  static int Function(int) _getMonkeyIdFunctionFromStringLines(String input) {
    RegExpMatch? match =
        RegExp(r'divisible by (\d+).* If true: throw to monkey (\d+).* If false: throw to monkey (\d+)')
            .firstMatch(input);
    String? divisibleByString = match?.group(1);
    String? caseTrueString = match?.group(2);
    String? caseFalseString = match?.group(3);
    if (divisibleByString == null || caseTrueString == null || caseFalseString == null) {
      throw Exception('monkey test is not found in `$input`');
    }

    int divisibleBy = int.parse(divisibleByString);
    int caseTrue = int.parse(caseTrueString);
    int caseFalse = int.parse(caseFalseString);

    return (int worryLevel) {
      if (worryLevel % divisibleBy == 0) {
        return caseTrue;
      }
      return caseFalse;
    };
  }
}
