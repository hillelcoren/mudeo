import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/ui/auth/login_vm.dart';

part 'ui_state.g.dart';

abstract class UIState implements Built<UIState, UIStateBuilder> {
  factory UIState() {
    return _$UIState._(
      currentRoute: LoginScreen.route,
      //quoteUIState: QuoteUIState(),
    );
  }

  UIState._();

  String get currentRoute;
  static Serializer<UIState> get serializer => _$uIStateSerializer;

  bool containsRoute(String route) => currentRoute.contains(route);
}
