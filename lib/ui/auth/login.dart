import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:mudeo/constants.dart';
import 'package:mudeo/main_common.dart';
import 'package:mudeo/ui/app/link_text.dart';
import 'package:mudeo/ui/app/app_button.dart';
import 'package:mudeo/ui/app/form_card.dart';
import 'package:mudeo/ui/auth/login_vm.dart';
import 'package:mudeo/utils/localization.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  //final _buttonController = RoundedLoadingButtonController();
  bool _isLoading = false;

  String _error = '';

  bool _showLogin = false;
  bool _showEmail = Platform.isAndroid ? false : true;
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
      _error = '';
    });

    if (!isValid) {
      //_buttonController.reset();
      return;
    }

    if (!_showLogin && !_termsChecked) {
      //_buttonController.reset();
      showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(localization.termsOfService),
              content: Text(localization.pleaseAgreeToTerms),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: TextButton(
                    autofocus: true,
                    child: Text(AppLocalization.of(context).close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            );
          });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final viewModel = widget.viewModel;
    final Completer<Null> completer = Completer<Null>();
    completer.future.then((_) {
      if (_showEmail) {
        //_buttonController.success();
      } else {
        //_buttonController.reset();
      }
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      //_buttonController.reset();
      setState(() {
        _isLoading = false;
        _error = error;
      });
    });

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
    final state = viewModel.state;
    final isOneTimePassword = _error.contains(OTP_ERROR) ||
        _oneTimePasswordController.text.isNotEmpty;

    final ThemeData themeData = Theme.of(context);
    final TextStyle aboutTextStyle = themeData.textTheme.bodyText1;
    final TextStyle linkStyle =
        themeData.textTheme.bodyText1.copyWith(color: themeData.accentColor);

    return SingleChildScrollView(
      primary: true,
      child: Column(
        children: <Widget>[
          Container(color: Colors.black, width: double.infinity, height: 20),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(30),
            child: Image.asset(
              'assets/images/logo-dark.png',
              width: 200,
            ),
          ),
          SizedBox(
            width: 380,
            child: Form(
              key: _formKey,
              child: FormCard(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            _ToggleButtons(
                              tabLabels: [
                                localization.signUp,
                                localization.login,
                              ],
                              selectedIndex: _showLogin ? 1 : 0,
                              onTabChanged: (index) {
                                setState(() {
                                  _error = '';
                                  _showLogin = index == 1;
                                });
                              },
                            ),
                            if (Platform.isAndroid)
                              _ToggleButtons(
                                tabLabels: [
                                  'Google',
                                  localization.email,
                                ],
                                selectedIndex: _showEmail ? 1 : 0,
                                onTabChanged: (index) {
                                  setState(() {
                                    _showEmail = index == 1;
                                  });
                                },
                              ),
                            SizedBox(height: 10),
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
                                    autovalidateMode: _autoValidate
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
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
                                    autovalidateMode: _autoValidate
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
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
                                    autovalidateMode: _autoValidate
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                    keyboardType: TextInputType.visiblePassword,
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
                                ? SizedBox()
                                : Padding(
                                    padding: EdgeInsets.only(top: 20),
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
                                              url: state.termsUrl,
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
                                              url: state.privacyUrl,
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
                  (_error ?? '').isEmpty || _error.contains(OTP_ERROR)
                      ? SizedBox(height: 35)
                      : Container(
                          padding: EdgeInsets.only(bottom: 20, top: 20),
                          child: Center(
                            child: Text(
                              _error,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                  ElevatedButton(
                      onPressed: _isLoading ? null : () => _submitForm(),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(_showLogin
                            ? (_showEmail
                                    ? localization.login
                                    : localization.loginWithGoogle)
                                .toUpperCase()
                            : (_showEmail
                                    ? localization.signUp
                                    : localization.signUpWithGoogle)
                                .toUpperCase()),
                      )),
                  /*
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
                  */
                  SizedBox(height: 15),
                  isOneTimePassword && !viewModel.isLoading
                      ? Padding(
                          padding: EdgeInsets.only(top: 12, bottom: 12),
                          child: AppButton(
                            label: localization.cancel.toUpperCase(),
                            color: Colors.grey,
                            onPressed: () {
                              setState(() {
                                _oneTimePasswordController.text = '';
                                _error = '';
                              });
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'YouTube',
                onPressed: () => launchUrlString(kMudeoYouTubeURL),
                icon: Icon(
                  MdiIcons.youtube,
                  size: 30,
                ),
                iconSize: 30,
              ),
              SizedBox(width: 8),
              IconButton(
                tooltip: 'Twitter',
                onPressed: () => launchUrlString(kMudeoTwitterURL),
                icon: Icon(
                  MdiIcons.twitter,
                  size: 30,
                ),
                iconSize: 30,
              ),
              SizedBox(width: 8),
              IconButton(
                tooltip: localization.website,
                onPressed: () => launchUrlString(kMudeoURL),
                icon: Icon(
                  MdiIcons.web,
                  size: 30,
                ),
                iconSize: 30,
              ),
              SizedBox(width: 8),
              IconButton(
                tooltip: localization.contactUs,
                onPressed: () => launchUrlString('mailto:$kMudeoContactEmail'),
                icon: Icon(
                  MdiIcons.email,
                  size: 30,
                ),
                iconSize: 30,
              ),
            ],
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _ToggleButtons extends StatelessWidget {
  const _ToggleButtons({
    @required this.selectedIndex,
    @required this.onTabChanged,
    @required this.tabLabels,
  });

  final List<String> tabLabels;
  final int selectedIndex;
  final Function(int) onTabChanged;

  @override
  Widget build(BuildContext context) {
    //final bool isDesktop = calculateLayout(context) != AppLayout.mobile;
    final bool isDesktop = false;
    final width = MediaQuery.of(context).size.width;
    final double toggleWidth = isDesktop ? 178 : (width - 70) / 2;

    return LayoutBuilder(builder: (context, layout) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: ToggleButtons(
          constraints: BoxConstraints(minWidth: (layout.maxWidth - 4) / 2),
          children: [
            Container(
              height: 40,
              child: Center(child: Text(tabLabels[0].toUpperCase())),
            ),
            Container(
              height: 40,
              child: Center(child: Text(tabLabels[1].toUpperCase())),
            ),
          ],
          isSelected: selectedIndex == 0 ? [true, false] : [false, true],
          onPressed: (index) => onTabChanged(index),
        ),
      );
    });
  }
}
