import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/utils/platforms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';

class WindowManager extends StatefulWidget {
  const WindowManager({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  State<WindowManager> createState() => _WindowManagerState();
}

class _WindowManagerState extends State<WindowManager> with WindowListener {
  @override
  void initState() {
    if (isDesktop()) {
      windowManager.addListener(this);
      _init();
    }

    super.initState();
  }

  void _init() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowResize() async {
    if (!isDesktop()) {
      return;
    }

    final size = await windowManager.getSize();
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(kSharedPrefWidth, size.width);
    prefs.setDouble(kSharedPrefHeight, size.height);
  }

  /*
  @override
  void onWindowClose() async {
    if (!isDesktop()) {
      return;
    }

    final store = StoreProvider.of<AppState>(navigatorKey.currentContext);

    if (await windowManager.isPreventClose()) {
      checkForChanges(
        store: store,
        callback: () async {
          await windowManager.destroy();
        },
      );
    }
  }
   */

  @override
  void dispose() {
    if (isDesktop()) {
      windowManager.removeListener(this);
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child!;
}