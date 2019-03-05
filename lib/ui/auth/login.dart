import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/ui/app/elevated_button.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/app/progress_button.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    Key key,
    @required this.viewModel,
  }) : super(key: key);

  final LoginVM viewModel;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginView> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _urlController = TextEditingController();
  final _secretController = TextEditingController();
  final _oneTimePasswordController = TextEditingController();

  static const String OTP_ERROR = 'OTP_REQUIRED';

  final FocusNode _focusNode1 = new FocusNode();

  bool _showLogin = false;
  bool _termsChecked = false;
  bool _autoValidate = false;

  @override
  void didChangeDependencies() {
    final state = widget.viewModel.authState;
    _emailController.text = state.email;
    _passwordController.text = state.password;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _secretController.dispose();

    super.dispose();
  }

  void _submitForm() {
    final bool isValid = _formKey.currentState.validate();

    setState(() {
      _autoValidate = !isValid;
    });

    if (!isValid) {
      return;
    }

    widget.viewModel.onLoginPressed(context,
        email: _emailController.text,
        password: _passwordController.text,
        url: _urlController.text,
        secret: _secretController.text,
        oneTimePassword: _oneTimePasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalization.of(context);
    final viewModel = widget.viewModel;
    final error = viewModel.authState.error ?? '';
    final isOneTimePassword =
        error.contains(OTP_ERROR) || _oneTimePasswordController.text.isNotEmpty;

    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.body2;
    final TextStyle linkStyle =
        themeData.textTheme.body2.copyWith(color: themeData.accentColor);

    if (!viewModel.authState.isInitialized) {
      return Container();
    }

    return Stack(
      children: <Widget>[
        SizedBox(
          height: 250.0,
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
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
              child: Placeholder(
                fallbackHeight: 100,
              ),
              /*
              child: Image.asset('assets/images/logo.png',
                  width: 100.0, height: 100.0),
                  */
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
                            TextFormField(
                              controller: _emailController,
                              autocorrect: false,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  labelText: localization.email),
                              keyboardType: TextInputType.emailAddress,
                              autovalidate: _autoValidate,
                              validator: (val) =>
                                  val.isEmpty || val.trim().isEmpty
                                      ? localization.pleaseEnterYourEmail
                                      : null,
                              onFieldSubmitted: (String value) =>
                                  FocusScope.of(context)
                                      .requestFocus(_focusNode1),
                            ),
                            TextFormField(
                              controller: _passwordController,
                              autocorrect: false,
                              autovalidate: _autoValidate,
                              decoration: InputDecoration(
                                  labelText: localization.password),
                              validator: (val) =>
                                  val.isEmpty || val.trim().isEmpty
                                      ? localization.pleaseEnterYourPassword
                                      : null,
                              obscureText: true,
                              focusNode: _focusNode1,
                              onFieldSubmitted: (value) => _submitForm(),
                            ),
                            _showLogin
                                ? SizedBox(
                                    height: 16,
                                  )
                                : Padding(
                                    padding: EdgeInsets.only(top: 16),
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
                                            _LinkTextSpan(
                                              style: linkStyle,
                                              url: kTermsOfServiceURL,
                                              text: localization.termsOfService,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                  viewModel.authState.error == null || error.contains(OTP_ERROR)
                      ? Container()
                      : Container(
                          padding: EdgeInsets.only(top: 16.0),
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
                  ProgressButton(
                    padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                    isLoading: viewModel.isLoading,
                    label:
                        (_showLogin ? localization.login : localization.signUp)
                            .toUpperCase(),
                    onPressed: () => _submitForm(),
                  ),
                  isOneTimePassword
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            FlatButton(
                                onPressed: () =>
                                    setState(() => _showLogin = !_showLogin),
                                child: Text(_showLogin
                                    ? localization.signUp
                                    : localization.login)),
                            FlatButton(
                                onPressed: () => viewModel.onGoogleLoginPressed(
                                    context,
                                    _urlController.text,
                                    _secretController.text),
                                child: Text(localization.googleLogin)),
                          ],
                        ),
                  isOneTimePassword && !viewModel.isLoading
                      ? Padding(
                          padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
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
    path.lineTo(0.0, size.height - 30);

    final firstControlPoint = Offset(size.width / 4, size.height);
    final firstPoint = Offset(size.width / 2, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstPoint.dx, firstPoint.dy);

    final secondControlPoint =
        Offset(size.width - (size.width / 4), size.height);
    final secondPoint = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondPoint.dx, secondPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceSafariVC: false);
              });
}
