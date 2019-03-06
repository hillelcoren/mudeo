import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/data/models/entities.dart';

part 'artist.g.dart';

abstract class ArtistState
    implements SelectableEntity, Built<ArtistState, ArtistStateBuilder> {
  factory ArtistState() {
    return _$ArtistState._(
      id: 0,
      firstName: '',
      lastName: '',
      handle: '',
      email: '',
    );
  }

  ArtistState._();

  @BuiltValueField(wireName: 'first_name')
  String get firstName;

  @BuiltValueField(wireName: 'last_name')
  String get lastName;

  @BuiltValueField(wireName: 'handle_name')
  String get handle;

  String get email;

  @override
  String get listDisplayName {
    return handle;
  }

  static Serializer<ArtistState> get serializer => _$artistStateSerializer;
}
