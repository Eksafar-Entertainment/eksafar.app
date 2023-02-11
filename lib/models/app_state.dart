class AppState {
  String? accessToken = null;
  List? locations = null;

  AppState({this.accessToken, this.locations});
  AppState.fromAppState(AppState another) {
    accessToken = another.accessToken;
    locations = another.locations;
  }
}