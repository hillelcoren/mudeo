import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/ui/app/link_text.dart';
import 'package:mudeo/ui/app/elevated_button.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final LoginVM viewModel;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _handleController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _oneTimePasswordController = TextEditingController();

  static const String OTP_ERROR = 'OTP_REQUIRED';

  final FocusNode _focusNode1 = new FocusNode();
  final FocusNode _focusNode2 = new FocusNode();
  final _buttonController = RoundedLoadingButtonController();

  bool _showLogin = false;
  bool _showEmail = false;
  bool _termsChecked = false;
  bool _autoValidate = false;

  @override
  void dispose() {
    _handleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _submitForm() {
    if (widget.viewModel.isLoading) {
      return;
    }

    final localization = AppLocalization.of(context);
    final bool isValid = _formKey.currentState.validate();

    setState(() {
      _autoValidate = !isValid;
    });

    if (!isValid) {
      _buttonController.reset();
      return;
    }

    if (!_showLogin && !_termsChecked) {
      _buttonController.reset();
      showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(localization.termsOfService),
              content: Text(localization.pleaseAgreeToTerms),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FlatButton(
                    child: Text(AppLocalization.of(context).close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            );
          });
      return;
    }

    final viewModel = widget.viewModel;
    final Completer<Null> completer = Completer<Null>();
    completer.future
        .then((_) => _buttonController.success())
        .catchError((_) => _buttonController.reset());

    if (_showLogin) {
      if (_showEmail) {
        viewModel.onLoginPressed(
          context,
          email: _emailController.text,
          password: _passwordController.text,
          oneTimePassword: _oneTimePasswordController.text,
          completer: completer,
        );
      } else {
        viewModel.onGoogleLoginPressed(context, completer: completer);
      }
    } else {
      if (_showEmail) {
        viewModel.onEmailSignUpPressed(
          context,
          handle: _handleController.text,
          email: _emailController.text,
          password: _passwordController.text,
          completer: completer,
        );
      } else {
        viewModel.onGoogleSignUpPressed(
          context,
          handle: _handleController.text,
          completer: completer,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final error = viewModel.authState.error ?? '';
    final isOneTimePassword =
        error.contains(OTP_ERROR) || _oneTimePasswordController.text.isNotEmpty;

    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.bodyText1;
    final TextStyle linkStyle =
        themeData.textTheme.bodyText1.copyWith(color: themeData.accentColor);

    return Stack(
      children: <Widget>[
        SizedBox(
          height: 250,
          child: ClipPath(
            clipper: ArcClipper(),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  //Colors.grey.shade800,
                  //Colors.black87,
                  Theme.of(context).buttonColor,
                  Theme.of(context).buttonColor.withOpacity(.7),
                ],
              )),
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 80, top: 60, right: 80, bottom: 20),
              child: Image.asset('assets/images/logo-dark.png'),
            ),
            Form(
              key: _formKey,
              child: FormCard(
                children: <Widget>[
                  isOneTimePassword
                      ? TextFormField(
                          controller: _oneTimePasswordController,
                          autocorrect: false,
                          decoration: InputDecoration(
                              labelText: localization.oneTimePassword),
                        )
                      : Column(
                          children: <Widget>[
                            _showLogin
                                ? SizedBox()
                                : TextFormField(
                                    controller: _handleController,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: localization.handle,
                                      icon: Icon(FontAwesomeIcons.at),
                                    ),
                                    keyboardType: TextInputType.text,
                                    autovalidate: _autoValidate,
                                    validator: (val) =>
                                        val.isEmpty || val.trim().isEmpty
                                            ? localization.pleaseEnterYourHandle
                                            : null,
                                    onFieldSubmitted: (String value) =>
                                        FocusScope.of(context)
                                            .requestFocus(_focusNode1),
                                  ),
                            _showEmail
                                ? TextFormField(
                                    controller: _emailController,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      labelText: localization.email,
                                      icon:
                                          Icon(FontAwesomeIcons.solidEnvelope),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    autovalidate: _autoValidate,
                                    validator: (val) =>
                                        val.isEmpty || val.trim().isEmpty
                                            ? localization.pleaseEnterYourEmail
                                            : null,
                                    focusNode: _focusNode1,
                                    onFieldSubmitted: (String value) =>
                                        FocusScope.of(context)
                                            .requestFocus(_focusNode2),
                                  )
                                : SizedBox(),
                            _showEmail
                                ? TextFormField(
                                    controller: _passwordController,
                                    autocorrect: false,
                                    autovalidate: _autoValidate,
                                    decoration: InputDecoration(
                                      labelText: localization.password,
                                      icon: Icon(FontAwesomeIcons.lock),
                                    ),
                                    validator: (val) => val.isEmpty ||
                                            val.trim().isEmpty
                                        ? localization.pleaseEnterYourPassword
                                        : null,
                                    obscureText: true,
                                    focusNode: _focusNode2,
                                    textInputAction: TextInputAction.done,
                                    /*
                                    onFieldSubmitted: (value) =>
                                        FocusScope.of(context)
                                            .requestFocus(null),
                                            */
                                  )
                                : SizedBox(),
                            _showLogin
                                ? SizedBox(
                                    height: 25,
                                  )
                                : Padding(
                                    padding:
                                        EdgeInsets.only(top: 20, bottom: 8),
                                    child: CheckboxListTile(
                                      onChanged: (value) =>
                                          setState(() => _termsChecked = value),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      activeColor:
                                          Theme.of(context).accentColor,
                                      value: _termsChecked,
                                      title: RichText(
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(
                                              style: aboutTextStyle,
                                              text: localization.iAgreeToThe +
                                                  ' ',
                                            ),
                                            LinkTextSpan(
                                              style: linkStyle,
                                              url: kTermsOfServiceURL,
                                              text: localization
                                                  .termsOfServiceLink,
                                            ),
                                            TextSpan(
                                              style: aboutTextStyle,
                                              text:
                                                  ' ' + localization.and + ' ',
                                            ),
                                            LinkTextSpan(
                                              style: linkStyle,
                                              url: kPrivacyPolicyURL,
                                              text: localization
                                                  .privacyPolicyLink,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                  SizedBox(height: 15),
                  viewModel.authState.error == null || error.contains(OTP_ERROR)
                      ? Container()
                      : Container(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Center(
                            child: Text(
                              viewModel.authState.error,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  RoundedLoadingButton(
                    height: 38,
                    color: Theme.of(context).buttonColor,
                    controller: _buttonController,
                    child: Text((_showLogin
                            ? (_showEmail
                                ? localization.emailLogin
                                : localization.loginWithGoogle)
                            : (_showEmail
                                ? localization.signUp
                                : localization.signUpWithGoogle))
                        .toUpperCase()),
                    onPressed: () => _submitForm(),
                  ),
                  SizedBox(height: 15),
                  isOneTimePassword
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Expanded(
                              child: FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      _showEmail = !_showEmail;
                                    });
                                  },
                                  child: Text(_showEmail
                                      ? (_showLogin
                                          ? localization.googleLogin
                                          : localization.googleSignUp)
                                      : (_showLogin
                                          ? localization.emailLogin
                                          : localization.emailSignUp))),
                            ),
                            Expanded(
                              child: FlatButton(
                                onPressed: () {
                                  viewModel.clearAuthError();
                                  setState(() {
                                    _showLogin = !_showLogin;
                                  });
                                },
                                child: Text(
                                  _showLogin
                                      ? (_showEmail
                                          ? localization.emailSignUp
                                          : localization.googleSignUp)
                                      : (_showEmail
                                          ? localization.emailLogin
                                          : localization.googleLogin),
                                ),
                              ),
                            ),
                          ],
                        ),
                  isOneTimePassword && !viewModel.isLoading
                      ? Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: ElevatedButton(
                            label: localization.cancel.toUpperCase(),
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                _oneTimePasswordController.text = '';
                              });
                              viewModel.onCancel2FAPressed();
                            },
                          ),
                        )
                      : Container(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// https://github.com/iampawan/Flutter-UI-Kit
class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    final secondControlPoint =
        Offset(size.width - (size.width / 4), size.height);
    final secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
