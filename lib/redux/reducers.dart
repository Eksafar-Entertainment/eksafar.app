import 'package:eksafar/redux/actions.dart';

import '../models/app_state.dart';

AppState appStateReducers(AppState state, dynamic action) {
  if (action is SaveTokenAction) {
    return saveToken(state, action);
  } else if (action is LogoutAction) {
    return logout(state, action);
  }
  return state;
}

AppState saveToken(AppState state, SaveTokenAction action) {
  state.accessToken = action.accessToken;
  return state;
}

AppState logout(AppState state, LogoutAction action) {
  state.accessToken = null;
  return state;
}