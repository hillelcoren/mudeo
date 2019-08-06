import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/data/models/song_model.dart';
import 'package:mudeo/utils/localization.dart';

class AddVideo extends StatefulWidget {
  AddVideo({
    this.onRemoteVideoSelected,
    this.onChildVideoSelected,
  });

  final Function(String) onRemoteVideoSelected;
  final Function(VideoEntity) onChildVideoSelected;

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  TextEditingController _textController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String convertToVideoId(String value) {
    value = value.trim();

    if (value.contains('v=')) {
      int index = value.indexOf('v=') + 2;
      value = value.substring(index, index + 11);
    } else if (value.contains('/')) {
      value = value.substring(value.lastIndexOf('/') + 1);
    }

    return value;
  }

  bool isValidVideoId(String value) => convertToVideoId(value).length == 11;

  void submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    Navigator.pop(context);
    widget.onRemoteVideoSelected(convertToVideoId(_textController.text));
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);

    return AlertDialog(
      content: Form(
        key: _formKey,
        child: TextFormField(
          //autofocus: true, // TODO enable after fix for #33293
          controller: _textController,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value.isEmpty) {
              return localization.pleaseProvideAValue;
            } else if (!isValidVideoId(value)) {
              return localization.errorInvalidValue;
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: localization.videoUrlOrId,
            icon: Icon(FontAwesomeIcons.youtube),
          ),
          onEditingComplete: () {
            submitForm();
          },
        ),
      ),
      actions: <Widget>[
        FlatButton(
            child: Text(localization.cancel.toUpperCase()),
            onPressed: () {
              Navigator.pop(context);
              _textController.clear();
            }),
        FlatButton(
          child: Text(localization.ok.toUpperCase()),
          onPressed: submitForm,
        ),
      ],
    );
  }
}
