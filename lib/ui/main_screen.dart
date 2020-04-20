import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/ui/artist/artist_page_vm.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/ui/song/song_list_vm.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ScrollController _songScrollController;
  ScrollController _profileScrollController;

  @override
  void initState() {
    super.initState();
    _songScrollController = ScrollController();
    _profileScrollController = ScrollController();
  }

  @override
  void dispose() {
    _songScrollController.dispose();
    _profileScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth > 700.0) {
        return DesktopScreen(
          viewModel: viewModel,
          songScrollController: _songScrollController,
          profileScrollController: _profileScrollController,
        );
      } else {
        return MobileScreen(
          viewModel: viewModel,
          songScrollController: _songScrollController,
          profileScrollController: _profileScrollController,
        );
      }
    });
  }
}

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({
    this.viewModel,
    this.songScrollController,
    this.profileScrollController,
  });

  final MainScreenVM viewModel;
  final ScrollController songScrollController;
  final ScrollController profileScrollController;

  @override
  _DesktopScreenState createState() => _DesktopScreenState();
}

class _DesktopScreenState extends State<DesktopScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: SongListScreen(
            scrollController: widget.songScrollController,
          ),
        ),
        Expanded(
          child: kIsWeb ? CustomPlaceholder() : SongEditScreen(),
          flex: 3,
        ),
      ],
    );
  }
}

class MobileScreen extends StatelessWidget {
  const MobileScreen({
    this.viewModel,
    this.songScrollController,
    this.profileScrollController,
  });

  final MainScreenVM viewModel;
  final ScrollController songScrollController;
  final ScrollController profileScrollController;

  static const TAB_LIST = 0;
  static const TAB_EDIT = 1;
  static const TAB_PROFILE = 2;

  @override
  Widget build(BuildContext context) {
    final state = viewModel.state;
    final uiState = state.uiState;

    if (kIsWeb) {
      return SongListScreen(
        scrollController: songScrollController,
      );
    }

    List<Widget> _views = [
      SongListScreen(
        scrollController: songScrollController,
      ),
      SongEditScreen(),
      if (!kIsWeb)
        if (state.authState.hasValidToken)
          ArtistScreen(
            artist: state.authState.artist,
            showSettings: true,
            scrollController: profileScrollController,
          )
        else
          LoginScreenBuilder(),
    ];
    final currentIndex = state.uiState.selectedTabIndex;

    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: CupertinoTabScaffold(
            key: ValueKey(uiState.song.id),
            tabBar: CupertinoTabBar(
              backgroundColor: Colors.black38,
              currentIndex: uiState.selectedTabIndex,
              onTap: (index) {
                final currentIndex = state.uiState.selectedTabIndex;
                if (currentIndex == kTabList && index == kTabList) {
                  songScrollController.animateTo(
                      songScrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic);
                } else if (currentIndex == kTabProfile &&
                    index == kTabProfile) {
                  profileScrollController.animateTo(
                      profileScrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic);
                }
                viewModel.onTabChanged(index);
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home,
                      color: currentIndex == TAB_LIST ? null : Colors.white),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.videocam,
                      color: currentIndex == TAB_EDIT ? null : Colors.white),
                ),
                if (!kIsWeb)
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person,
                        color:
                            currentIndex == TAB_PROFILE ? null : Colors.white),
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

class CustomPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Thank you for checking out the app!'),
            SizedBox(height: 10),
            Text('To record please download the mobile app'),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  child: Image.asset(
                    'assets/images/google.png',
                    width: 150,
                  ),
                  onTap: () {
                    launch(kGoogleStoreUrl, forceSafariVC: false);
                  },
                ),
                SizedBox(width: 20),
                InkWell(
                  child: Image.asset(
                    'assets/images/apple.png',
                    width: 150,
                  ),
                  onTap: () {
                    launch(kAppleStoreUrl, forceSafariVC: false);
                  },
                )
              ],
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text(
                      'Follow Us',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      color: Colors.black,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.twitter),
                          SizedBox(width: 12),
                          Text('@mudeo_app'),
                        ],
                      ),
                      onPressed: () {
                        launch(kTwitterURL, forceSafariVC: false);
                      },
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: <Widget>[
                    Text(
                      'Developed By',
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    RaisedButton(
                      color: Colors.black,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(FontAwesomeIcons.twitter),
                          SizedBox(width: 12),
                          Text('@hillelcoren'),
                        ],
                      ),
                      onPressed: () {
                        launch(kDeveloperURL, forceSafariVC: false);
                      },
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 50),
            Text(
              'If you have a GitHub account please\nconsider upvoting this issue 👍 to help complete\nthe app by enabling recording in the browser',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            RaisedButton(
              color: Colors.black,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(FontAwesomeIcons.github),
                  SizedBox(width: 12),
                  Text('GitHub Issue #45297'),
                ],
              ),
              onPressed: () {
                launch('https://github.com/flutter/flutter/issues/45297',
                    forceSafariVC: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
