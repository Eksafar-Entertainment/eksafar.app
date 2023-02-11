class SaveTokenAction {
  final String accessToken;
  SaveTokenAction(this.accessToken);
}

class SaveLocationsAction {
  final List locations;
  SaveLocationsAction(this.locations);
}

class LogoutAction {
  LogoutAction();
}