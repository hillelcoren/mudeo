import 'dart:async';
import 'dart:io';

import 'package:mudeo/utils/platforms.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileStorage {
  const FileStorage(
    this.tag,
    this.getDirectory,
  );

  final String tag;
  final Future<Directory> Function() getDirectory;

  Future<File> _getLocalFile() async {
    final directory = await getDirectory();

    // TODO remove this
    if (isMobile()) {
      return File('${directory.path}/invoiceninja__$tag.json');
    }

    final String folder = p.join(directory.path, 'mudeo', 'cache');
    await Directory(folder).create(recursive: true);
    return File(p.join(folder, 'mudeo_$tag.json'));
  }

  Future<dynamic> load() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(tag);
    } else {
      final file = await _getLocalFile();
      final contents = await file.readAsString();

      return contents;
    }
  }

  Future<File> save(String data) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(tag, data);

      return null;
    } else {
      final file = await _getLocalFile();

      return file.writeAsString(data);
    }
  }

  Future<FileSystemEntity> delete() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(tag);
      return null;
    } else {
      final file = await _getLocalFile();

      return file.delete();
    }
  }

  Future<bool> exists() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.containsKey(tag);
    } else {
      final file = await _getLocalFile();

      return file.existsSync();
    }
  }
}
