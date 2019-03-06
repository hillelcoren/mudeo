import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/ui/main_screen_vm.dart';

class MainView extends StatelessWidget {
  const MainView({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final MainScreenVM viewModel;

  @override
  Widget build(BuildContext context) {
    return Text('testing');
  }
}
