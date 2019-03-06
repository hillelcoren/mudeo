import 'package:flutter/cupertino.dart';

class ArtistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: SizedBox(),
        middle: Text('Page 2 of tab'),
      ),
      child: Center(
        child: CupertinoButton(
          child: const Text('Back'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
