import 'package:flutter/material.dart';
import 'dart:async';

class LocationStream {
  LocationStream() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_count >= 1) {
        _controller.sink.add(_count);
        _count--;
        //print(_count);
      } else {
        _controller.close();
      }
    });
  }
  var _count = 5;
  final _controller = StreamController<int>();

  Stream<int> get stream => _controller.stream.asBroadcastStream();
}
