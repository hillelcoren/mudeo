import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:mudeo/data/file_storage.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/data/models/serializers.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:mudeo/redux/ui/ui_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceRepository {
  const PersistenceRepository({
    @required this.fileStorage,
  });

  final FileStorage fileStorage;

  Future<File> saveDataState(DataState state) async {
    /*
    final stateWithoutToken = state.rebuild(
            (b) => b..data.replace(state.data.rebuild((b) => b..token = '')));
    */
    final data =
    serializers.serializeWith(DataState.serializer, state);
    return await fileStorage.save(json.encode(data));
  }

  Future<DataState> loadDataState() async {
    final String data = await fileStorage.load();
    final dataState =
    serializers.deserializeWith(DataState.serializer, json.decode(data));

    return dataState;
  }

  Future<File> saveAuthState(AuthState state) async {
    final data = serializers.serializeWith(AuthState.serializer, state);
    return await fileStorage.save(json.encode(data));
  }

  Future<AuthState> loadAuthState() async {
    final String data = await fileStorage.load();
    return serializers.deserializeWith(AuthState.serializer, json.decode(data));
  }

  Future<File> saveUIState(UIState state) async {
    final data = serializers.serializeWith(UIState.serializer, state);
    return await fileStorage.save(json.encode(data));
  }

  Future<UIState> loadUIState() async {
    final String data = await fileStorage.load();
    return serializers.deserializeWith(UIState.serializer, json.decode(data));
  }

  Future<FileSystemEntity> delete() async {
    return await fileStorage
        .exists()
        .then((exists) => exists ? fileStorage.delete() : null);
  }

  Future<bool> exists() async {
    return await fileStorage.exists();
  }
}

/*
AppState _deserialize(String data) {
  return serializers.deserializeWith(AppState.serializer, json.decode(data));
}
*/
