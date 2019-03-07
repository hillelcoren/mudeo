import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:mudeo/utils/localization.dart';

class MainScreen extends StatelessWidget {
  static String route = '/main';

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    List<Widget> _views = [
      SongListScreen(),
      Placeholder(),
      Container(
        child: Center(
          child: FlatButton(
            child: Text('logout'),
            onPressed: () {
              final store = StoreProvider.of<AppState>(context);
              store.dispatch(UserLogout());
              Navigator.of(context).pushReplacementNamed(LoginScreen.route);
            },
          ),
        ),
      ),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text(localization.explore),
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            title: Text(localization.create),
            icon: Icon(Icons.video_call),
          ),
          BottomNavigationBarItem(
            title: Text(localization.profile),
            icon: Icon(Icons.person),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return _views[index];
      },
    );
  }
}
