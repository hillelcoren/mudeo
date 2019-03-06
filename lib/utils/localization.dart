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
      'views': 'views',
      'african': 'African',
      'arabic': 'Arabic',
      'asian': 'Asian',
      'avant_garde': 'Avant-garde',
      'blues': 'Blues',
      'caribbean': 'Caribbean',
      'comedy': 'Comedy',
      'country': 'Country',
      'easy_listening': 'Easy listening',
      'electronic': 'Electronic',
      'folk': 'Folk',
      'hip_hop': 'Hip hop',
      'jazz': 'Jazz',
      'latin': 'Latin',
      'pop': 'Pop',
      'rb_and_soul': 'R&B and Soul',
      'rock': 'Rock',
      'classical_music': 'Classical Music',
      'other': 'Other',
      'edit': 'Edit',
      'explore': 'Explore',
      'create': 'Create',
      'profile': 'Profile',
      'handle': 'Handle',
      'close': 'Close',
      'please_agree_to_terms':
          'Please agree to the terms of service to create a new account.',
      'already_have_an_account': 'Already have an account? Tap here to login',
      'do_not_have_an_account':
          'Don\'t have an account? Tap here to create one',
      'play': 'Play',
      'cancel': 'Cancel',
      'one_time_password': 'One Time Password',
      'email': 'Email',
      'login': 'Login',
      'sign_up': 'Sign Up',
      'password': 'Password',
      'please_enter_your_handle': 'Please enter your handle',
      'please_enter_your_email': 'Please enter your email',
      'please_enter_your_password': 'Please enter your password',
      'google_login': 'Google Login',
      'i_agree_to_the': 'I agree to the',
      'terms_of_service': 'Terms of Service',
      'terms_of_service_link': 'terms of service',
    },
  };

  String get edit => _localizedValues[locale.toString()]['edit'];

  String get explore => _localizedValues[locale.toString()]['explore'];

  String get create => _localizedValues[locale.toString()]['create'];

  String get profile => _localizedValues[locale.toString()]['profile'];

  String get handle => _localizedValues[locale.toString()]['handle'];

  String get close => _localizedValues[locale.toString()]['close'];

  String get doNotHaveAnAccount =>
      _localizedValues[locale.toString()]['do_not_have_an_account'];

  String get pleaseAgreeToTerms =>
      _localizedValues[locale.toString()]['please_agree_to_terms'];

  String get alreadyHaveAnAccount =>
      _localizedValues[locale.toString()]['already_have_an_account'];

  String get iAgreeToThe =>
      _localizedValues[locale.toString()]['i_agree_to_the'];

  String get termsOfService =>
      _localizedValues[locale.toString()]['terms_of_service'];

  String get termsOfServiceLink =>
      _localizedValues[locale.toString()]['terms_of_service_link'];

  String get cancel => _localizedValues[locale.toString()]['cancel'];

  String get googleLogin => _localizedValues[locale.toString()]['google_login'];

  String get pleaseEnterYourEmail =>
      _localizedValues[locale.toString()]['please_enter_your_email'];

  String get play => _localizedValues[locale.toString()]['play'];

  String get login => _localizedValues[locale.toString()]['login'];

  String get signUp => _localizedValues[locale.toString()]['sign_up'];

  String get pleaseEnterYourPassword =>
      _localizedValues[locale.toString()]['please_enter_your_password'];

  String get pleaseEnterYourHandle =>
      _localizedValues[locale.toString()]['please_enter_your_handle'];

  String get password => _localizedValues[locale.toString()]['password'];

  String get email => _localizedValues[locale.toString()]['email'];

  String get oneTimePassword =>
      _localizedValues[locale.toString()]['one_time_password'];

  String get african => _localizedValues[locale.toString()]['african'];

  String get arabic => _localizedValues[locale.toString()]['arabic'];

  String get asian => _localizedValues[locale.toString()]['asian'];

  String get avantGarde => _localizedValues[locale.toString()]['avant_garde'];

  String get blues => _localizedValues[locale.toString()]['blues'];

  String get caribbean => _localizedValues[locale.toString()]['caribbean'];

  String get comedy => _localizedValues[locale.toString()]['comedy'];

  String get country => _localizedValues[locale.toString()]['country'];

  String get easyListening =>
      _localizedValues[locale.toString()]['easy_listening'];

  String get electronic => _localizedValues[locale.toString()]['electronic'];

  String get folk => _localizedValues[locale.toString()]['folk'];

  String get hipHop => _localizedValues[locale.toString()]['hip_hop'];

  String get jazz => _localizedValues[locale.toString()]['jazz'];

  String get latin => _localizedValues[locale.toString()]['latin'];

  String get pop => _localizedValues[locale.toString()]['pop'];

  String get rBAndSoul => _localizedValues[locale.toString()]['rb_and_soul'];

  String get rock => _localizedValues[locale.toString()]['rock'];

  String get classicalMusic =>
      _localizedValues[locale.toString()]['classical_music'];

  String get other => _localizedValues[locale.toString()]['other'];

  String get views => _localizedValues[locale.toString()]['views'];

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
