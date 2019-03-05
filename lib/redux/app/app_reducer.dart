import 'package:mudeo/redux/app/app_state.dart';
import 'package:mudeo/redux/app/loading_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  /*
  if (action is UserLogout) {
    return AppState().rebuild((b) => b
      ..authState.replace(state.authState)
      ..uiState.enableDarkMode = state.uiState.enableDarkMode);
  } else if (action is LoadStateSuccess) {
    return action.state.rebuild((b) => b
      ..isLoading = false
      ..isSaving = false
    );
  }
  */
  return state.rebuild((b) => b
    ..isLoading = loadingReducer(state.isLoading, action)
    ..isSaving = savingReducer(state.isSaving, action)
    //..authState.replace(authReducer(state.authState, action))
  );
}
