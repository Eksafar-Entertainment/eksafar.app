import 'package:eksafar/models/app_state.dart';
import 'package:eksafar/redux/reducers.dart';
import 'package:redux/redux.dart';

final Store<AppState> appStore = Store<AppState>(appStateReducers, initialState: AppState(accessToken: null));