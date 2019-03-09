import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:mudeo/ui/app/app_builder.dart';
import 'package:mudeo/ui/auth/login.dart';
import 'package:mudeo/ui/main_screen.dart';
import 'package:mudeo/utils/platforms.dart';
import 'package:redux/redux.dart';

class LoginScreenBuilder extends StatelessWidget {
  const LoginScreenBuilder({Key key}) : super(key: key);

  static const String route = '/login';

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
    @required this.isLoading,
    @required this.authState,
    @required this.onLoginPressed,
    @required this.onSignUpPressed,
    @required this.onCancel2FAPressed,
    @required this.onGoogleLoginPressed,
  });

  bool isLoading;
  AuthState authState;
  final Function() onCancel2FAPressed;
  final Function(BuildContext, {String handle, String email, String password})
      onSignUpPressed;
  final Function(BuildContext,
      {String email, String password, String oneTimePassword}) onLoginPressed;

  /*
  final Function(BuildContext,
      {String email,
      String password,
      String handle)) onSignUpPressed;
  */
  final Function(BuildContext, String, String) onGoogleLoginPressed;

  static LoginVM fromStore(Store<AppState> store) {
    /*
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'openid',
        'profile',
      ],
    );
    */

    void _handleLogin(BuildContext context) {
      print('_handleLogin');
      AppBuilder.of(context).rebuild();
      //store.dispatch(ViewDashboard(context));
      Navigator.of(context).pushReplacementNamed(MainScreen.route);
    }

    return LoginVM(
        isLoading: store.state.isLoading,
        authState: store.state.authState,
        onCancel2FAPressed: () => store.dispatch(ClearAuthError()),
        /*
        onGoogleLoginPressed:
            (BuildContext context, String url, String secret) async {
          try {
            final account = await _googleSignIn.signIn();

            if (account != null) {
              account.authentication.then((GoogleSignInAuthentication value) {
                final Completer<Null> completer = Completer<Null>();
                store.dispatch(OAuthLoginRequest(
                  completer: completer,
                  token: value.idToken,
                  url: url.trim(),
                  secret: secret.trim(),
                  platform: getPlatform(context),
                ));
                completer.future.then((_) => _handleLogin(context));
              });
            }
          } catch (error) {
            print(error);
          }
        },
        */
        onSignUpPressed: (BuildContext context,
            {String handle, String email, String password}) {
          if (store.state.isLoading) {
            return;
          }

          final Completer<Null> completer = Completer<Null>();
          store.dispatch(UserSignUpRequest(
            completer: completer,
            handle: handle.trim(),
            email: email.trim(),
            password: password.trim(),
            platform: getPlatform(context),
          ));
          completer.future.then((_) => _handleLogin(context));
        },
        onLoginPressed: (BuildContext context,
            {String email, String password, String oneTimePassword}) async {
          if (store.state.isLoading) {
            return;
          }

          final Completer<Null> completer = Completer<Null>();
          store.dispatch(UserLoginRequest(
            completer: completer,
            email: email.trim(),
            password: password.trim(),
            platform: getPlatform(context),
            oneTimePassword: oneTimePassword.trim(),
          ));
          completer.future.then((_) => _handleLogin(context));
        });
  }
}
