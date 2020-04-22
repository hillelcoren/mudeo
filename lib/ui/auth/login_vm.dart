import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:mudeo/redux/song/song_actions.dart';
import 'package:mudeo/ui/app/app_builder.dart';
import 'package:mudeo/ui/auth/login.dart';
import 'package:mudeo/utils/platforms.dart';
import 'package:redux/redux.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreenBuilder extends StatelessWidget {
  const LoginScreenBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoreConnector<AppState, LoginVM>(
        converter: LoginVM.fromStore,
        builder: (context, viewModel) {
          return LoginScreen(
            viewModel: viewModel,
          );
        },
      ),
    );
  }
}

class LoginVM {
  LoginVM({
    @required this.state,
    @required this.isLoading,
    @required this.authState,
    @required this.clearAuthError,
    @required this.onLoginPressed,
    @required this.onEmailSignUpPressed,
    @required this.onCancel2FAPressed,
    @required this.onGoogleSignUpPressed,
    @required this.onGoogleLoginPressed,
  });

  AppState state;
  bool isLoading;
  AuthState authState;
  final Function() clearAuthError;
  final Function() onCancel2FAPressed;
  final Function(BuildContext,
      {String handle,
      String email,
      String password,
      Completer<Null> completer}) onEmailSignUpPressed;
  final Function(BuildContext, {String handle, Completer<Null> completer})
      onGoogleSignUpPressed;
  final Function(BuildContext,
      {String email,
      String password,
      String oneTimePassword,
      Completer<Null> completer}) onLoginPressed;
  final Function(BuildContext, {Completer<Null> completer})
      onGoogleLoginPressed;

  static LoginVM fromStore(Store<AppState> store) {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'openid',
        'profile',
      ],
    );

    void _handleLogin(BuildContext context) {
      AppBuilder.of(context).rebuild();
      store.dispatch(LoadSongs(clearCache: true));
    }

    return LoginVM(
        state: store.state,
        isLoading: store.state.isLoading,
        authState: store.state.authState,
        onCancel2FAPressed: () => store.dispatch(ClearAuthError()),
        onGoogleSignUpPressed: (BuildContext context,
            {String handle, Completer<Null> completer}) async {
          try {
            final account = await _googleSignIn.signIn();
            if (account != null) {
              account.authentication.then((GoogleSignInAuthentication value) {
                store.dispatch(GoogleSignUpRequest(
                  completer: completer,
                  //oauthToken: value.accessToken,
                  oauthId: account.id,
                  handle: handle,
                  email: account.email,
                  name: account.displayName,
                  photoUrl: account.photoUrl,
                ));
                completer.future.then((_) => _handleLogin(context));
              });
            }
          } catch (error) {
            completer.completeError(error);
            print(error);
          }
        },
        onGoogleLoginPressed: (BuildContext context,
            {Completer<Null> completer}) async {
          try {
            final account = await _googleSignIn.signIn();
            if (account != null) {
              account.authentication.then((GoogleSignInAuthentication value) {
                store.dispatch(GoogleLoginRequest(
                  completer: completer,
                  oauthToken: value.idToken,
                ));
                completer.future.then((_) => _handleLogin(context));
              });
            }
          } catch (error) {
            completer.completeError(error);
            print(error);
          }
        },
        onEmailSignUpPressed: (BuildContext context,
            {String handle,
            String email,
            String password,
            Completer<Null> completer}) {
          if (store.state.isLoading) {
            return;
          }

          store.dispatch(UserSignUpRequest(
            completer: completer,
            handle: handle.trim(),
            email: email.trim(),
            password: password.trim(),
          ));
          completer.future.then((_) => _handleLogin(context));
        },
        clearAuthError: () => store.dispatch(ClearAuthError()),
        onLoginPressed: (BuildContext context,
            {String email,
            String password,
            String oneTimePassword,
            Completer<Null> completer}) async {
          if (store.state.isLoading) {
            return;
          }

          store.dispatch(UserLoginRequest(
            completer: completer,
            email: email.trim(),
            password: password.trim(),
            platform: getPlatform(),
            oneTimePassword: oneTimePassword.trim(),
          ));
          completer.future.then((_) => _handleLogin(context));
        });
  }
}
