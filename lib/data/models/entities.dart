import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/data/models/artist.dart';
import 'package:mudeo/data/models/song.dart';

part 'entities.g.dart';

abstract class ErrorMessage
    implements Built<ErrorMessage, ErrorMessageBuilder> {
  factory ErrorMessage([void updates(ErrorMessageBuilder b)]) = _$ErrorMessage;

  ErrorMessage._();

  String get message;

  static Serializer<ErrorMessage> get serializer => _$errorMessageSerializer;
}

abstract class LoginResponse
    implements Built<LoginResponse, LoginResponseBuilder> {
  factory LoginResponse([void updates(LoginResponseBuilder b)]) =
      _$LoginResponse;

  LoginResponse._();

  LoginResponseData get data;

  @nullable
  ErrorMessage get error;

  static Serializer<LoginResponse> get serializer => _$loginResponseSerializer;
}

abstract class LoginResponseData
    implements Built<LoginResponseData, LoginResponseDataBuilder> {
  factory LoginResponseData([void updates(LoginResponseDataBuilder b)]) =
      _$LoginResponseData;

  LoginResponseData._();

  String get version;

  static Serializer<LoginResponseData> get serializer =>
      _$loginResponseDataSerializer;
}

abstract class DataState implements Built<DataState, DataStateBuilder> {
  factory DataState() {
    return _$DataState._(
        //songMap: BuiltMap<int, SongEntity>(),
        songMap: BuiltMap({
          1: SongEntity().rebuild((b) => b
            ..title = 'test 1'
            ..artistId = 1
            ..genreId = 12
            ..duration = 20
            ..playCount = 50
            ..description =
                'This is a test description of the song. Some more words to make it longs and some more.'
            ..tracks.replace([TrackEntity(), TrackEntity(), TrackEntity()])),
          2: SongEntity().rebuild((b) => b
            ..title = 'test 2'
            ..artistId = 2
            ..genreId = 8
            ..playCount = 100
            ..tracks.replace([
              TrackEntity(),
              TrackEntity(),
              TrackEntity(),
              TrackEntity(),
              TrackEntity()
            ])),
          3: SongEntity().rebuild((b) => b
            ..title = 'test 1'
            ..artistId = 1
            ..genreId = 1
            ..description =
                'This is a test description of the song. Some more words to make it longs and some more.'
            ..tracks.replace([TrackEntity(), TrackEntity(), TrackEntity()])),
        }),
        artistMap: BuiltMap({
          1: ArtistEntity().rebuild((b) => b..handle = 'first'),
          2: ArtistEntity().rebuild((b) => b..handle = 'second'),
        }));
  }

  DataState._();

  BuiltMap<int, SongEntity> get songMap;

  BuiltMap<int, ArtistEntity> get artistMap;

  static Serializer<DataState> get serializer => _$dataStateSerializer;
}

abstract class SelectableEntity {
  @nullable
  int get id;

  String get listDisplayName => 'Error: listDisplayName not set';
}
