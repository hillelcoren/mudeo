import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/redux/app/app_actions.dart';
import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/ui/app/first_interaction.dart';
import 'package:mudeo/ui/artist/artist_page_vm.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:mudeo/ui/song/song_edit_vm.dart';
import 'package:mudeo/ui/song/song_list_paged_vm.dart';
import 'package:mudeo/ui/song/song_prefs.dart';
import 'package:mudeo/utils/dialogs.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:mudeo/utils/platforms.dart';
import 'package:mudeo/utils/web_stub.dart'
    if (dart.library.html) 'package:mudeo/utils/web.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MainScreenBuilder extends StatelessWidget {
  const MainScreenBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MainScreenVM>(
      onInit: (Store<AppState> store) async {
        final prefs = await SharedPreferences.getInstance();
        final localization = AppLocalization.of(context);
        if (!kIsWeb &&
            prefs.getBool(kSharedPrefShownVideo) != true &&
            store.state.helpVideoId != null) {
          prefs.setBool(kSharedPrefShownVideo, true);
          confirmCallback(
            message: localization.welcomeToTheApp
                .replaceFirst(':name', store.state.appName),
            context: context,
            areYouSure: localization.wantToWatchTheVideo,
            confirmLabel: localization.sure,
            declineLabel: localization.noThanks,
            callback: () {
              /*
              FlutterYoutube.playYoutubeVideoById(
                apiKey: Config.YOU_TUBE_API_KEY,
                videoId: store.state.helpVideoId,
                autoPlay: true,
                fullScreen: true,
                appBarColor: Colors.black12,
                backgroundColor: Colors.black,
              );
               */
              launch(
                  'https://www.youtube.com/watch?v=${store.state.helpVideoId}');
            },
          );
        }
      },
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
  ScrollController _profileScrollController;
  PageController _featuredSongsPageController;
  PageController _unfeaturedSongsPageController;

  @override
  void initState() {
    super.initState();
    _profileScrollController = ScrollController();
    _featuredSongsPageController = PageController();
    _unfeaturedSongsPageController = PageController();
  }

  @override
  void dispose() {
    _profileScrollController.dispose();
    _featuredSongsPageController.dispose();
    _unfeaturedSongsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;

    return FirstInteractionTracker(
      child: SongPreferencesWidget(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > kDesktopBreakpoint && kIsWeb) {
            return DesktopScreen(
              viewModel: viewModel,
              profileScrollController: _profileScrollController,
              songPageController: _featuredSongsPageController,
            );
          } else {
            return MobileScreen(
              viewModel: viewModel,
              profileScrollController: _profileScrollController,
              featuredSongsPageController: _featuredSongsPageController,
              unfeaturedSongsPageController: _unfeaturedSongsPageController,
            );
          }
        }),
      ),
    );
  }
}

class DesktopScreen extends StatefulWidget {
  const DesktopScreen({
    @required this.viewModel,
    @required this.profileScrollController,
    @required this.songPageController,
  });

  final MainScreenVM viewModel;
  final ScrollController profileScrollController;
  final ScrollController songPageController;

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
          child: SongListPagedScreen(
            pageController: widget.songPageController,
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

class ScreenTabs {
  static const LIST_FEATURED = 0;
  static const LIST_ALL = 1;
  static const EDIT = 2;
  static const PROFILE = 3;
}

class MobileScreen extends StatefulWidget {
  const MobileScreen({
    @required this.viewModel,
    @required this.profileScrollController,
    @required this.featuredSongsPageController,
    @required this.unfeaturedSongsPageController,
  });

  final MainScreenVM viewModel;
  final ScrollController profileScrollController;
  final PageController featuredSongsPageController;
  final PageController unfeaturedSongsPageController;

  @override
  State<MobileScreen> createState() => _MobileScreenState();
}

class _MobileScreenState extends State<MobileScreen> {
  final InAppReview _inAppReview = InAppReview.instance;

  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);
    final state = widget.viewModel.state;
    final uiState = state.uiState;

    if (kIsWeb) {
      return SongListPagedScreen(
        pageController: widget.featuredSongsPageController,
      );
    }

    List<Widget> _views = [
      SongListPagedScreen(
        pageController: widget.featuredSongsPageController,
        isFeatured: true,
      ),
      SongListPagedScreen(
        pageController: widget.unfeaturedSongsPageController,
        isFeatured: false,
      ),
      SongEditScreen(),
      if (!kIsWeb)
        if (state.authState.hasValidToken)
          ArtistScreen(
            artist: state.authState.artist,
            showSettings: true,
            scrollController: widget.profileScrollController,
          )
        else
          LoginScreenBuilder(),
    ];
    final currentIndex = state.uiState.selectedTabIndex;
    final localization = AppLocalization.of(context);

    return Column(
      children: [
        Expanded(
          child: CupertinoTabScaffold(
            key: ValueKey(uiState.song.id),
            tabBar: CupertinoTabBar(
              backgroundColor: Colors.black38,
              currentIndex: uiState.selectedTabIndex,
              onTap: (index) {
                final currentIndex = state.uiState.selectedTabIndex;
                if (currentIndex == ScreenTabs.LIST_FEATURED &&
                    index == ScreenTabs.LIST_FEATURED) {
                  widget.featuredSongsPageController.animateTo(0,
                      duration: Duration(milliseconds: 5),
                      curve: Curves.easeInOutCubic);
                } else if (currentIndex == ScreenTabs.LIST_ALL &&
                    index == ScreenTabs.LIST_ALL) {
                  widget.unfeaturedSongsPageController.animateTo(0,
                      duration: Duration(milliseconds: 5),
                      curve: Curves.easeInOutCubic);
                } else if (currentIndex == ScreenTabs.PROFILE &&
                    index == ScreenTabs.PROFILE) {
                  widget.profileScrollController.animateTo(
                      widget.profileScrollController.position.minScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic);
                }
                widget.viewModel.onTabChanged(index);
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: currentIndex == ScreenTabs.LIST_FEATURED
                      ? localization.featured
                      : null,
                  icon: Icon(MdiIcons.trophy,
                      color: currentIndex == ScreenTabs.LIST_FEATURED
                          ? null
                          : Colors.white),
                ),
                BottomNavigationBarItem(
                  label: currentIndex == ScreenTabs.LIST_ALL
                      ? localization.newest
                      : null,
                  icon: Icon(MdiIcons.playlistMusic,
                      color: currentIndex == ScreenTabs.LIST_ALL
                          ? null
                          : Colors.white),
                ),
                BottomNavigationBarItem(
                  label: currentIndex == ScreenTabs.EDIT
                      ? localization.record
                      : null,
                  icon: Icon(Icons.videocam,
                      color: currentIndex == ScreenTabs.EDIT
                          ? null
                          : Colors.white),
                ),
                if (!kIsWeb)
                  BottomNavigationBarItem(
                    label: currentIndex == ScreenTabs.PROFILE
                        ? localization.profile
                        : null,
                    icon: Icon(Icons.person,
                        color: currentIndex == ScreenTabs.PROFILE
                            ? null
                            : Colors.white),
                  ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              return _views[index];
            },
          ),
        ),
        if (state.authState.showAppReview)
          Material(
            color: Colors.black,
            child: Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    localization.wouldYouRateTheApp,
                  ),
                )),
                TextButton(
                  onPressed: () async {
                    store.dispatch(HideReviewApp());
                    final isAvailable = await _inAppReview.isAvailable();
                    if (isAvailable && !isAndroid()) {
                      _inAppReview.requestReview();
                    } else {
                      _inAppReview.openStoreListing(
                          appStoreId:
                              isAndroid() ? kPlayStoreAppId : kAppStoreAppId,
                          microsoftStoreId: kMicrosoftAppStoreId);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(localization.sure),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    store.dispatch(HideReviewApp());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(localization.noThanks),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class CustomPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final store = StoreProvider.of<AppState>(context);

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
                HandCursor(
                  child: InkWell(
                    child: Image.asset(
                      'assets/images/google.png',
                      width: 150,
                    ),
                    onTap: () {
                      launch(
                          store.state.isDance
                              ? kDanceGoogleStoreUrl
                              : kMudeoGoogleStoreUrl,
                          forceSafariVC: false);
                    },
                  ),
                ),
                SizedBox(width: 20),
                HandCursor(
                  child: InkWell(
                    child: Image.asset(
                      'assets/images/apple.png',
                      width: 150,
                    ),
                    onTap: () {
                      launch(
                          store.state.isDance
                              ? kDanceAppleStoreUrl
                              : kMudeoAppleStoreUrl,
                          forceSafariVC: false);
                    },
                  ),
                )
              ],
            ),
            /*
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
                    HandCursor(
                      child: RaisedButton(
                        color: Colors.black,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(FontAwesomeIcons.twitter),
                            SizedBox(width: 12),
                            Text('@${store.state.twitterHandle}'),
                          ],
                        ),
                        onPressed: () {
                          launch(store.state.twitterUrl, forceSafariVC: false);
                        },
                      ),
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
                    HandCursor(
                      child: RaisedButton(
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
            HandCursor(
              child: RaisedButton(
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
            ),
             */
          ],
        ),
      ),
    );
  }
}
