import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/data/models/artist_model.dart';
import 'package:mudeo/data/models/song_model.dart';

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
      songsUpdateAt: 0,
      songMap: BuiltMap<int, SongEntity>(),
      artistMap: BuiltMap<int, ArtistEntity>(),
    );
  }

  DataState._();

  int get songsUpdateAt;

  BuiltMap<int, SongEntity> get songMap;

  BuiltMap<int, ArtistEntity> get artistMap;

  bool get areSongsStale {
    if (!areSongsLoaded) {
      return true;
    }

    return DateTime.now().millisecondsSinceEpoch - songsUpdateAt >
        kMillisecondsToRefreshData;
  }

  bool get areSongsLoaded => songsUpdateAt > 0;

  static Serializer<DataState> get serializer => _$dataStateSerializer;
}

abstract class SelectableEntity {
  @nullable
  int get id;

  String get listDisplayName => 'Error: listDisplayName not set';
}

class EntityAction extends EnumClass {
  const EntityAction._(String name) : super(name);

  static Serializer<EntityAction> get serializer => _$entityActionSerializer;

  static const EntityAction like = _$like;

  static BuiltSet<EntityAction> get values => _$values;

  static EntityAction valueOf(String name) => _$valueOf(name);
}

abstract class BaseEntity implements SelectableEntity {
  /*
  @nullable
  @BuiltValueField(wireName: 'created_at')
  int get createdAt;
  */

  @nullable
  @BuiltValueField(wireName: 'deleted_at')
  String get deletedAt;

  @nullable
  @BuiltValueField(wireName: 'updated_at')
  String get updatedAt;

  String get entityKey => '__${entityType}__${id}__';

  EntityType get entityType => throw 'EntityType not set: ${this}';

  bool get isNew => id == null || id < 0;

/*
  List<EntityAction> getBaseActions({UserEntity user}) {
    final actions = <EntityAction>[];

    if (user.canEditEntity(this) && (isArchived || isDeleted)) {
      actions.add(EntityAction.restore);
    }

    if (user.canEditEntity(this) && isActive) {
      actions.add(EntityAction.archive);
    }

    if (user.canEditEntity(this) && (isActive || isArchived)) {
      actions.add(EntityAction.delete);
    }

    return actions;
  }
  */

}

class EntityType extends EnumClass {
  const EntityType._(String name) : super(name);

  static Serializer<EntityType> get serializer => _$entityTypeSerializer;

  static const EntityType song = _$song;

  static BuiltSet<EntityType> get values => _$typeValues;

  static EntityType valueOf(String name) => _$typeValueOf(name);
}
