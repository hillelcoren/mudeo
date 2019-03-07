import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/data/models/entities.dart';

part 'artist.g.dart';

abstract class ArtistEntity
    implements SelectableEntity, Built<ArtistEntity, ArtistEntityBuilder> {
  factory ArtistEntity() {
    return _$ArtistEntity._(
      id: 0,
      firstName: '',
      lastName: '',
      handle: '',
      email: '',
      token: '',
    );
  }

  ArtistEntity._();

  @nullable
  @BuiltValueField(wireName: 'first_name')
  String get firstName;

  @nullable
  @BuiltValueField(wireName: 'last_name')
  String get lastName;

  @nullable
  @BuiltValueField(wireName: 'handle')
  String get handle;

  String get email;

  String get token;

  @override
  String get listDisplayName {
    return handle;
  }

  static Serializer<ArtistEntity> get serializer => _$artistEntitySerializer;
}
