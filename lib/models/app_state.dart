class AppState {
  String? accessToken;
  List? locations;

  AppState({this.accessToken, this.locations});
  AppState.fromAppState(AppState another) {
    accessToken = another.accessToken;
    locations = another.locations;
  }
}