import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:mudeo/data/models/entities.dart';
import 'package:mudeo/redux/auth/auth_state.dart';
import 'package:mudeo/redux/ui/ui_state.dart';

part 'app_state.g.dart';

abstract class AppState implements Built<AppState, AppStateBuilder> {
  factory AppState(
      {String appVersion, bool enableDarkMode, bool requireAuthentication}) {
    return _$AppState._(
      isLoading: false,
      isSaving: false,
      authState: AuthState(),
      dataState: DataState(),
      uiState: UIState(),
    );
  }

  AppState._();

  bool get isLoading;

  bool get isSaving;

  AuthState get authState;

  DataState get dataState;

  UIState get uiState;

  static Serializer<AppState> get serializer => _$appStateSerializer;

  /*
  bool get isLoaded {
    return dashboardState.isLoaded &&
        productState.isLoaded &&
        clientState.isLoaded;
  }
  */

  @override
  String toString() {
    //return 'Is Loading: ${this.isLoading}, Invoice: ${this.invoiceUIState.selected}';
    //return 'Date Formats: ${staticState.dateFormatMap}';
    //return 'Route: ${uiState.currentRoute}';
    return 'Index: ${uiState.selectedTabIndex}';
  }
}
