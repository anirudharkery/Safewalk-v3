import 'dart:ffi';

class Direction {
  Direction(
      {required this.distance, required this.streetName, required this.turn});
  String streetName;
  String turn;
  int distance;
}

class Route {
  List<String> instructions = [];
  Double distance;
  Double duration;

  Route(
      {required this.instructions,
      required this.distance,
      required this.duration});
}
