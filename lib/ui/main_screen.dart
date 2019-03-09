import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:redux/redux.dart';


class MainScreenBuilder extends StatelessWidget {
  const MainScreenBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MainScreenVM>(
      converter: MainScreenVM.fromStore,
      builder: (context, vm) {
        return MainScreen(
          viewModel: vm,
        );
      },
    );
  }
}

class MainScreenVM {
  MainScreenVM({
    @required this.state,
    @required this.isLoading,
    @required this.isLoaded,
    @required this.onTabChanged,
  });

  final AppState state;
  final bool isLoading;
  final bool isLoaded;
  final Function(int) onTabChanged;

  static MainScreenVM fromStore(Store<AppState> store) {
    final state = store.state;

    return MainScreenVM(
      //clientMap: state.clientState.map,
      state: state,
      isLoading: state.isLoading,
      isLoaded: true,
      onTabChanged: (index) => store.dispatch(MainTabChanged(index)),
    );
  }
}


class MainScreen extends StatelessWidget {
  static String route = '/main';

  const MainScreen({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final MainScreenVM viewModel;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    List<Widget> _views = [
      SongListScreen(),
      SongEditScreen(),
      Container(
        child: Center(
          child: RaisedButton(
            child: Text('logout'),
            onPressed: () {
              final store = StoreProvider.of<AppState>(context);
              store.dispatch(UserLogout());
              Navigator.of(context).pushReplacementNamed(LoginScreenBuilder.route);
            },
          ),
        ),
      ),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: viewModel.state.uiState.selectedTabIndex,
        onTap: (index) => viewModel.onTabChanged(index),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            //title: Text(localization.explore),
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            //title: Text(localization.create),
            icon: Icon(Icons.videocam),
          ),
          BottomNavigationBarItem(
            //title: Text(localization.profile),
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
