import 'dart:async';
import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Future<String> webFilePicker() {
  final completer = new Completer<String>();
  final InputElement input = document.createElement('input');
  input
    ..type = 'file'
    ..accept = 'image/*';
  input.onChange.listen((e) async {
    final List<File> files = input.files;
    final reader = new FileReader();
    reader.readAsDataUrl(files[0]);
    reader.onError.listen((error) => completer.completeError(error));
    await reader.onLoad.first;
    completer.complete(reader.result as String);
  });
  input.click();
  return completer.future;
}

void webReload() => window.location.reload();

void registerWebView(String html) {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      html,
      (int viewId) => IFrameElement()
        ..src = html
        ..style.border = 'none');
}

// TODO remove this once supported by Flutter
class HandCursor extends StatelessWidget {
  const HandCursor({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (PointerHoverEvent evt) {
        window.document.documentElement.style.cursor = 'pointer';
      },
      onExit: (PointerExitEvent evt) {
        window.document.documentElement.style.cursor = 'auto';
      },
      child: child,
    );
  }
}


/**
 * Utils for device detection.
 */
class Device {
  static bool _isOpera;
  static bool _isIE;
  static bool _isFirefox;
  static bool _isWebKit;
  static String _cachedCssPrefix;
  static String _cachedPropertyPrefix;
  /**
   * Gets the browser's user agent. Using this function allows tests to inject
   * the user agent.
   * Returns the user agent.
   */
  static String get userAgent => window.navigator.userAgent;
  /**
   * Determines if the current device is running Opera.
   */
  static bool get isOpera {
    if (_isOpera == null) {
      _isOpera = userAgent.contains("Opera", 0);
    }
    return _isOpera;
  }
  /**
   * Determines if the current device is running Internet Explorer.
   */
  static bool get isIE {
    if (_isIE == null) {
      _isIE = !isOpera && userAgent.contains("Trident/", 0);
    }
    return _isIE;
  }
  /**
   * Determines if the current device is running Firefox.
   */
  static bool get isFirefox {
    if (_isFirefox == null) {
      _isFirefox = userAgent.contains("Firefox", 0);
    }
    return _isFirefox;
  }
  /**
   * Determines if the current device is running WebKit.
   */
  static bool get isWebKit {
    if (_isWebKit == null) {
      _isWebKit = !isOpera && userAgent.contains("WebKit", 0);
    }
    return _isWebKit;
  }
  /**
   * Gets the CSS property prefix for the current platform.
   */
  static String get cssPrefix {
    String prefix = _cachedCssPrefix;
    if (prefix != null) return prefix;
    if (isFirefox) {
      prefix = '-moz-';
    } else if (isIE) {
      prefix = '-ms-';
    } else if (isOpera) {
      prefix = '-o-';
    } else {
      prefix = '-webkit-';
    }
    return _cachedCssPrefix = prefix;
  }
  /**
   * Prefix as used for JS property names.
   */
  static String get propertyPrefix {
    String prefix = _cachedPropertyPrefix;
    if (prefix != null) return prefix;
    if (isFirefox) {
      prefix = 'moz';
    } else if (isIE) {
      prefix = 'ms';
    } else if (isOpera) {
      prefix = 'o';
    } else {
      prefix = 'webkit';
    }
    return _cachedPropertyPrefix = prefix;
  }
  /**
   * Checks to see if the event class is supported by the current platform.
   */
  static bool isEventTypeSupported(String eventType) {
    // Browsers throw for unsupported event names.
    try {
      var e = new Event.eventType(eventType, '');
      return e is Event;
    } catch (_) { }
    return false;
  }
}