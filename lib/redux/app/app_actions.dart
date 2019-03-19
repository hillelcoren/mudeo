import 'dart:async';

abstract class PersistUI {}
abstract class PersistData {}
abstract class PersistAuth {}

abstract class StartLoading {}
abstract class StopLoading {}

abstract class StartSaving {}
abstract class StopSaving {}

class RefreshData {
  RefreshData({this.completer});

  final Completer completer;
}

class UpdateTabIndex implements PersistUI {
  UpdateTabIndex(this.index);

  final int index;
}
