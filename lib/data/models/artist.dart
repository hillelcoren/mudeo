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
      description: '',
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

  @nullable
  String get email;

  String get token;

  @nullable
  String get description;

  @override
  String get listDisplayName {
    return handle;
  }

  String get fullName => '$firstName $lastName';

  static Serializer<ArtistEntity> get serializer => _$artistEntitySerializer;
}
