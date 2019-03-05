import 'dart:async';

class PersistUI {}

class PersistData {}

class StartLoading {}

class StopLoading {}

class StartSaving {}

class StopSaving {}

class UserSettingsChanged implements PersistUI {
  UserSettingsChanged(
      {this.enableDarkMode,
      this.emailPayment,
      this.requireAuthentication,
      this.autoStartTasks});

  final bool enableDarkMode;
  final bool emailPayment;
  final bool requireAuthentication;
  final bool autoStartTasks;
}

class LoadDataSuccess {
  LoadDataSuccess({this.loginResponse, this.completer});

  final Completer completer;
  final dynamic loginResponse;
}

class RefreshData {
  RefreshData({this.platform, this.completer});

  final String platform;
  final Completer completer;
}

class FilterCompany {
  FilterCompany(this.filter);

  final String filter;
}
