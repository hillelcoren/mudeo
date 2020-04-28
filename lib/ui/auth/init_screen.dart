import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:redux/redux.dart';

class InitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      onInit: (Store<AppState> store) {
        store.dispatch(LoadStateRequest(context));
      },
      builder: (BuildContext context, Store<AppState> store) {
        return Container(
          color: Colors.black26,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 80, top: 20, right: 80, bottom: 20),
                  child: kIsWeb
                      ? SizedBox()
                      : Image.asset('assets/images/logo-dark.png'),
                ),
              ),
              SizedBox(
                height: 4.0,
                child: LinearProgressIndicator(),
              )
            ],
          ),
        );
      },
    );
  }
}
