import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/ui/main_screen.dart';
import 'package:redux/redux.dart';
import 'package:mudeo/utils/localization.dart';

class MainScreen extends StatelessWidget {
  static const String route = '/main';

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Scaffold'),
      ),
      body: MainScreenBuilder(),
    );
  }
}


class MainScreenBuilder extends StatelessWidget {
  const MainScreenBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MainScreenVM>(
      converter: MainScreenVM.fromStore,
      builder: (context, viewModel) {
        return MainView(viewModel: viewModel);
      },
    );
  }
}

class MainScreenVM {
  MainScreenVM({
    @required this.state,
    @required this.onLogoutTap,
    @required this.onRefreshTap,
  });

  static MainScreenVM fromStore(Store<AppState> store) {
    /*
    void _refreshData(BuildContext context) async {
      final completer = snackBarCompleter(
          context, AppLocalization.of(context).refreshComplete,
          shouldPop: true);
      store.dispatch(RefreshData(
        platform: getPlatform(context),
        completer: completer,
      ));
      await showDialog<AlertDialog>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => SimpleDialog(
            children: <Widget>[LoadingDialog()],
          ));
      AppBuilder.of(context).rebuild();
      store.dispatch(LoadDashboard());
    }

    void _confirmLogout(BuildContext context) {
      final localization = AppLocalization.of(context);
      showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          semanticLabel: localization.areYouSure,
          title: Text(localization.areYouSure),
          actions: <Widget>[
            new FlatButton(
                child: Text(localization.cancel.toUpperCase()),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: Text(localization.ok.toUpperCase()),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.route, (Route<dynamic> route) => false);
                  store.dispatch(UserLogout());
                })
          ],
        ),
      );
    }
    */

    return MainScreenVM(
      state: store.state,
      //onLogoutTap: (BuildContext context) => _confirmLogout(context),
      //onRefreshTap: (BuildContext context) => _refreshData(context),
    );
  }

  final AppState state;
  final Function(BuildContext context) onLogoutTap;
  final Function(BuildContext context) onRefreshTap;
}
