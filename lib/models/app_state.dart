class AppState {
  String? accessToken = null;

  AppState({this.accessToken});
  AppState.fromAppState(AppState another) {
    accessToken = another.accessToken;
  }
}