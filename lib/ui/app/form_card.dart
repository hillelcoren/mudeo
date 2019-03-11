import 'package:flutter/material.dart';

class FormCard extends StatelessWidget {
  const FormCard({
    Key key,
    this.crossAxisAlignment,
    this.mainAxisSize,
    @required this.children,
  }) : super(key: key);

  final List<Widget> children;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 2),
      child: Card(
        elevation: 4.0,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 16.0, top: 20.0, right: 16.0, bottom: 15.0),
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: mainAxisSize ?? MainAxisSize.max,
              crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
