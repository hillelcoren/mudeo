import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/app/data_reducer.dart';
import 'package:mudeo/redux/app/loading_reducer.dart';
import 'package:mudeo/redux/app/ui_reducer.dart';
import 'package:mudeo/redux/auth/auth_actions.dart';
import 'package:mudeo/redux/auth/auth_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is UserLogout) {
    return AppState(isDance: state.isDance)
        .rebuild((b) => b..authState.replace(state.authState.reset));
    //..uiState.enableDarkMode = state.uiState.enableDarkMode);
  } else if (action is LoadStateSuccess) {
    return action.state.rebuild((b) => b
      ..isLoading = false
      ..isSaving = false);
  }

  return state.rebuild((b) => b
    ..isLoading = loadingReducer(state.isLoading, action)
    ..isSaving = savingReducer(state.isSaving, action)
    ..authState.replace(authReducer(state.authState, action))
    ..dataState.replace(dataReducer(state.dataState, action))
    ..uiState.replace(uiReducer(state.uiState, action)));
}
