import 'package:flutter/material.dart';

class PageAnimation extends Animation<double>
    with
        AnimationLazyListenerMixin,
        AnimationLocalListenersMixin,
        AnimationLocalStatusListenersMixin {
  PageAnimation({
    required this.index,
    required this.controller,
    this.curve = Curves.fastOutSlowIn,
  })  : _value = 1.0,
        assert(controller != null),
        assert(curve != null);

  final int index;
  final PageController controller;
  final Curve curve;

  double _value;

  @override
  AnimationStatus get status => AnimationStatus.forward;

  @override
  double get value => _value;

  @override
  void didStartListening() {
    controller.addListener(_onPageScrolled);
  }

  void _onPageScrolled() {
    final relOffset = (1.0 - ((controller.page! - index).abs() * 2.0));
    final value = curve.transform(relOffset.clamp(0.0, 1.0));
    if (value != _value) {
      _value = value;
      notifyListeners();
    }
  }

  @override
  void didStopListening() {
    controller.removeListener(_onPageScrolled);
  }

  @override
  String toString() => 'PageAnimation($index, $controller)';
}
