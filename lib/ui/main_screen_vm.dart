import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/ui/main_screen.dart';
import 'package:redux/redux.dart';
import 'package:mudeo/utils/localization.dart';

class MainScreen extends StatefulWidget {
  static const String route = '/main';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    final List<Widget> _children = [
      Placeholder(),
      Placeholder(
        color: Colors.green,
      ),
      Placeholder(),
    ];

    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black45,
        onTap: (index) => setState(() => _selectedIndex = index),
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text(localization.explore),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_call),
            title: Text(localization.create),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), title: Text(localization.profile))
        ],
      ),
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
