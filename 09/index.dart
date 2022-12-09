import 'dart:io';
import 'dart:math';

void main(List<String> args) {
  File inputFile = File('./09/input.txt');
  List<Move> moves = inputFile.readAsStringSync().split('\n').fold(<Move>[], (moves, line) {
    final List<String> splittedLine = line.split(' ');
    final Move move = Move.fromString(splittedLine[0]);
    final int moveRepeat = int.parse(splittedLine[1]);
    moves.addAll(List.filled(moveRepeat, move));
    return moves;
  }).toList();

  print('---------- PART I ----------');
  print(partOne(moves, 2));
  print('---------- PART II ----------');
  print(partOne(moves, 10));
}

int partOne(List<Move> moves, int nbOfKnots) {
  State state = State(nbOfKnots);
  moves.forEach(state.executeMove);
  return state.tail.nbOfVisitedPositions;
}

class State {
  final List<Knot> knots;

  State._(this.knots);

  factory State(int nbOfKnots) {
    List<Knot> knots = [];
    Knot? current;
    for (int i = 0; i < nbOfKnots; i++) {
      current = Knot(current, i == nbOfKnots - 1);
      knots.add(current);
    }
    return State._(knots);
  }

  Knot get tail => knots.last;

  void executeMove(Move move) {
    knots.forEach((Knot knot) => knot.executeMove(move));
  }
}

class Knot {
  final Knot? _previous;
  final bool isLastKnot;
  Point<int> _position = Point<int>(0, 0);
  List<Point<int>> _visitedPositions = [Point<int>(0, 0)];

  Knot(this._previous, this.isLastKnot);
  int get nbOfVisitedPositions => _visitedPositions.length;

  void executeMove(Move move) {
    if (_previous == null) {
      _position += move.delta;
      return;
    }

    Point<int> previousPosition = _previous!._position;

    if (_position == previousPosition) return;

    Point<int> vector = previousPosition - _position;
    if (vector.x.abs() <= 1 && vector.y.abs() <= 1) return;

    if (vector.x.abs() == 2) {
      vector = Point<int>(vector.x ~/ 2, vector.y);
    }

    if (vector.y.abs() == 2) {
      vector = Point<int>(vector.x, vector.y ~/ 2);
    }

    _position += vector;
    if (isLastKnot && !_visitedPositions.contains(_position)) {
      _visitedPositions.add(_position);
    }
  }

  Point<int> get position => _position;
}

enum MoveType { up, down, left, right }

class Move {
  final MoveType type;
  final Point<int> delta;

  Move._(this.type, this.delta);

  factory Move.fromString(String type) {
    switch (type) {
      case 'U':
        return Move._(MoveType.up, Point<int>(0, 1));
      case 'D':
        return Move._(MoveType.down, Point<int>(0, -1));
      case 'L':
        return Move._(MoveType.left, Point<int>(-1, 0));
      case 'R':
        return Move._(MoveType.right, Point<int>(1, 0));
    }
    throw Exception('type $type unknown');
  }
}
