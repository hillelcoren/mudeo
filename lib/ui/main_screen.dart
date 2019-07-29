import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/ui/artist/artist_page_vm.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
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
    @required this.onTabChanged,
  });

  final AppState state;
  final Function(int) onTabChanged;

  static MainScreenVM fromStore(Store<AppState> store) {
    return MainScreenVM(
      state: store.state,
      onTabChanged: (index) => store.dispatch(UpdateTabIndex(index)),
    );
  }
}

class MainScreen extends StatefulWidget {
  static String route = '/main';

  const MainScreen({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final MainScreenVM viewModel;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final state = viewModel.state;
    final uiState = state.uiState;

    List<Widget> _views = [
      SongListScreen(
        scrollController: _scrollController,
      ),
      SongEditScreen(),
      ArtistScreen(
        artist: state.authState.artist,
        showSettings: true,
      ),
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: CupertinoTabScaffold(
            key: ValueKey(uiState.song.id),
            tabBar: CupertinoTabBar(
              currentIndex: uiState.selectedTabIndex,
              onTap: (index) {
                final currentIndex = state.uiState.selectedTabIndex;
                if (currentIndex == kTabList && index == kTabList) {
                  _scrollController.animateTo(
                      _scrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic);
                }
                viewModel.onTabChanged(index);
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.videocam),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return _views[index];
            },
          ),
        ),
      ),
    );
  }
}
