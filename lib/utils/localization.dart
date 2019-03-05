import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:mudeo/constants.dart';
import 'package:mudeo/utils/strings.dart';

class AppLocalization {
  AppLocalization(this.locale);

  final Locale locale;

  static Locale createLocale(String locale) {
    final parts = locale.split('_');
    return Locale(parts[0], parts.length > 1 ? parts[1] : null);
  }

  static AppLocalization of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'already_have_an_account': 'Already have an account? Tap here to login',
      'play': 'Play',
      'cancel': 'Cancel',
      'one_time_password': 'One Time Password',
      'email': 'Email',
      'login': 'Login',
      'create_account': 'Create a new account',
      'sign_up': 'Sign Up',
      'password': 'Password',
      'please_enter_your_email': 'Please enter your email',
      'please_enter_your_password': 'Please enter your password',
      'google_login': 'Google Login',
      'i_agree_to_the': 'I agree to the',
      'terms_of_service': 'terms of service',
    },
  };

  String get createAccount =>
      _localizedValues[locale.toString()]['create_account'];

  String get alreadyHaveAnAccount =>
      _localizedValues[locale.toString()]['already_have_an_account'];

  String get iAgreeToThe =>
      _localizedValues[locale.toString()]['i_agree_to_the'];

  String get termsOfService =>
      _localizedValues[locale.toString()]['terms_of_service'];

  String get cancel =>
      _localizedValues[locale.toString()]['cancel'];

  String get googleLogin =>
      _localizedValues[locale.toString()]['google_login'];

  String get pleaseEnterYourEmail =>
      _localizedValues[locale.toString()]['please_enter_your_email'];

  String get play =>
      _localizedValues[locale.toString()]['play'];

  String get login =>
      _localizedValues[locale.toString()]['login'];

  String get signUp =>
      _localizedValues[locale.toString()]['sign_up'];

  String get pleaseEnterYourPassword =>
      _localizedValues[locale.toString()]['please_enter_your_password'];

  String get password =>
      _localizedValues[locale.toString()]['password'];

  String get email =>
      _localizedValues[locale.toString()]['email'];

  String get oneTimePassword =>
      _localizedValues[locale.toString()]['one_time_password'];


  String lookup(String key) {
    final lookupKey = toSnakeCase(key);
    return _localizedValues[locale.toString()][lookupKey] ??
        _localizedValues[locale.toString()]
        [lookupKey.replaceFirst('_id', '')] ??
        key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => kLanguages.contains(locale.toString());

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture<AppLocalization>(AppLocalization(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
