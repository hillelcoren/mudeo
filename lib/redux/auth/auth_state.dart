import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_state.g.dart';

abstract class AuthState implements Built<AuthState, AuthStateBuilder> {
  factory AuthState() {
    return _$AuthState._(
      userId: 0,
      email: '',
      password: '',
      token: '',
      isAuthenticated: false,
      isInitialized: false,
    );
  }

  AuthState._();

  int get userId;

  String get token;

  String get email;

  String get password;

  bool get isInitialized;

  bool get isAuthenticated;

  @nullable
  String get error;

  AuthState get reset => rebuild((b) => b
    ..userId = 0
    ..token = null
    ..error = null
    ..password = null
    ..isInitialized = true
    ..isAuthenticated = false);

  //factory AuthState([void updates(AuthStateBuilder b)]) = _$AuthState;
  static Serializer<AuthState> get serializer => _$authStateSerializer;
}
