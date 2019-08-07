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
      'add_all': 'Add All',
      'parent': 'Parent',
      'child': 'Child',
      'delete_song': 'Delete Song',
      'source': 'Source',
      'successfully_added_video': 'Successfully added video',
      'error_invalid_value': 'Error: Invalid value',
      'please_provide_a_value': 'Please provide a value',
      'video_url_or_id': 'Video URL or Id',
      'add_video': 'Add Video',
      'delete_comment': 'Delete Comment',
      'no_comments': 'No Comments',
      'no_videos': 'No Videos',
      'comment': 'Comment',
      'comments': 'Comments',
      'view_original': 'View Original',
      'add_a_public_comment': 'Add a public comment...',
      'done': 'Done',
      'track_adjustment': 'Track Adjustment',
      'adjust': 'Adjust',
      'calibrate': 'Calibrate',
      'milliseconds': 'Milliseconds',
      'block_artist': 'Block Artist',
      'copied_to_clipboard': 'Copied to clipboard',
      'copy_link_to_song': 'Copy link to Song',
      'report_song': 'Report Song',
      'share_song': 'Share Song',
      'note': 'Note',
      'headphone_warning':
          'Please wear headphones when recording to prevent an echo',
      'email_us': 'Email Us',
      'header_image': 'Header Image',
      'profile_image': 'Profile Image',
      'use_google': 'Use Google',
      'use_email': 'Use Email',
      'open_in_browser': 'Open in Browser',
      'remove': 'Remove',
      'remove_video': 'Remove Video',
      'reset_song': 'Reset Song',
      'new_song': 'New Song',
      'logout_app': 'Logout App',
      'logout_from_the_app': 'Logout from the app',
      'version': 'Version',
      'thank_you_for_using_our_app': 'Thank you for using our app!',
      'if_you_like_it': 'If you like it please',
      'click_here': 'click here',
      'to_rate_it': 'to rate it.',
      'about': 'About',
      'uploading_video_of': 'Uploading video :current of :total',
      'your_song_has_been_saved': 'Your song has been saved!',
      'uploading': 'Uploading',
      'follow': 'Follow',
      'unfollow': 'Unfollow',
      'genre': 'Genre',
      'front': 'Front',
      'back': 'Back',
      'external': 'External',
      'settings': 'Settings',
      'select_camera': 'Select Camera',
      'edit_profile': 'Edit Profile',
      'delete_account': 'Delete Account',
      'preview': 'Preview',
      'name': 'Name',
      'website': 'Website',
      'logout': 'Logout',
      'volume': 'Volume',
      'solo': 'Solo',
      'clear': 'Clear',
      'lose_changes': 'This will discard any unsaved changes',
      'ok': 'Ok',
      'are_you_sure': 'Are you sure?',
      'like': 'Like',
      'share': 'Share',
      'public': 'Public',
      'upload': 'Upload',
      'save': 'Save',
      'description': 'Description',
      'title': 'Title',
      'field_is_required': 'Field is required',
      'stop': 'Stop',
      'delete': 'Delete',
      'record': 'Record',
      'refresh_complete': 'Refresh complete',
      'dismiss': 'Dismiss',
      'an_error_occurred': 'An error occurred',
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
      'profile': 'Profile',
      'handle': 'Handle',
      'close': 'Close',
      'please_agree_to_terms':
          'Please agree to the terms of service and privacy policy to create an account.',
      'play': 'Play',
      'cancel': 'Cancel',
      'one_time_password': 'One Time Password',
      'email': 'Email',
      'login': 'Login',
      'login_with_google': 'Login with Google',
      'sign_up': 'Sign Up',
      'sign_up_with_google': 'Sign Up with Google',
      'password': 'Password',
      'please_enter_your_handle': 'Please enter your handle',
      'please_enter_your_email': 'Please enter your email',
      'please_enter_your_password': 'Please enter your password',
      'google_login': 'Google Login',
      'i_agree_to_the': 'I agree to the',
      'and': 'and',
      'terms_of_service': 'Terms of Service',
      'terms_of_service_link': 'terms of service',
      'privacy_policy_link': 'privacy policy',
      'audio_latency': 'Audio Latency',
    },
  };

  String get blockArtist => _localizedValues[locale.toString()]['block_artist'];

  String get note => _localizedValues[locale.toString()]['note'];

  String get headphoneWarning =>
      _localizedValues[locale.toString()]['headphone_warning'];

  String get headerImage => _localizedValues[locale.toString()]['header_image'];

  String get profileImage =>
      _localizedValues[locale.toString()]['profile_image'];

  String get emailUs => _localizedValues[locale.toString()]['email_us'];

  String get useGoogle => _localizedValues[locale.toString()]['use_google'];

  String get useEmail => _localizedValues[locale.toString()]['use_email'];

  String get openInBrowser =>
      _localizedValues[locale.toString()]['open_in_browser'];

  String get remove => _localizedValues[locale.toString()]['remove'];

  String get removeVideo => _localizedValues[locale.toString()]['remove_video'];

  String get resetSong => _localizedValues[locale.toString()]['reset_song'];

  String get newSong => _localizedValues[locale.toString()]['new_song'];

  String get logoutApp => _localizedValues[locale.toString()]['logout_app'];

  String get logoutFromTheApp =>
      _localizedValues[locale.toString()]['logout_from_the_app'];

  String get version => _localizedValues[locale.toString()]['version'];

  String get thankYouForUsingOurApp =>
      _localizedValues[locale.toString()]['thank_you_for_using_our_app'];

  String get ifYouLikeIt =>
      _localizedValues[locale.toString()]['if_you_like_it'];

  String get clickHere => _localizedValues[locale.toString()]['click_here'];

  String get toRateIt => _localizedValues[locale.toString()]['to_rate_it'];

  String get about => _localizedValues[locale.toString()]['about'];

  String get uploadingVideoOf =>
      _localizedValues[locale.toString()]['uploading_video_of'];

  String get yourSongHasBeenSaved =>
      _localizedValues[locale.toString()]['your_song_has_been_saved'];

  String get uploading => _localizedValues[locale.toString()]['uploading'];

  String get follow => _localizedValues[locale.toString()]['follow'];

  String get unfollow => _localizedValues[locale.toString()]['unfollow'];

  String get genre => _localizedValues[locale.toString()]['genre'];

  String get front => _localizedValues[locale.toString()]['front'];

  String get back => _localizedValues[locale.toString()]['back'];

  String get external => _localizedValues[locale.toString()]['external'];

  String get settings => _localizedValues[locale.toString()]['settings'];

  String get selectCamera =>
      _localizedValues[locale.toString()]['select_camera'];

  String get editProfile => _localizedValues[locale.toString()]['edit_profile'];

  String get deleteAccount =>
      _localizedValues[locale.toString()]['delete_account'];

  String get preview => _localizedValues[locale.toString()]['preview'];

  String get name => _localizedValues[locale.toString()]['name'];

  String get website => _localizedValues[locale.toString()]['website'];

  String get volume => _localizedValues[locale.toString()]['volume'];

  String get loseChanges => _localizedValues[locale.toString()]['lose_changes'];

  String get ok => _localizedValues[locale.toString()]['ok'];

  String get solo => _localizedValues[locale.toString()]['solo'];

  String get clear => _localizedValues[locale.toString()]['clear'];

  String get areYouSure => _localizedValues[locale.toString()]['are_you_sure'];

  String get like => _localizedValues[locale.toString()]['like'];

  String get share => _localizedValues[locale.toString()]['share'];

  String get delete => _localizedValues[locale.toString()]['delete'];

  String get stop => _localizedValues[locale.toString()]['stop'];

  String get record => _localizedValues[locale.toString()]['record'];

  String get privacyPolicyLink =>
      _localizedValues[locale.toString()]['privacy_policy_link'];

  String get and => _localizedValues[locale.toString()]['and'];

  String get edit => _localizedValues[locale.toString()]['edit'];

  String get explore => _localizedValues[locale.toString()]['explore'];

  String get profile => _localizedValues[locale.toString()]['profile'];

  String get handle => _localizedValues[locale.toString()]['handle'];

  String get close => _localizedValues[locale.toString()]['close'];

  String get title => _localizedValues[locale.toString()]['title'];

  String get fieldIsRequired =>
      _localizedValues[locale.toString()]['field_is_required'];

  String get pleaseAgreeToTerms =>
      _localizedValues[locale.toString()]['please_agree_to_terms'];

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

  String get logout => _localizedValues[locale.toString()]['logout'];

  String get signUp => _localizedValues[locale.toString()]['sign_up'];

  String get signUpWithGoogle =>
      _localizedValues[locale.toString()]['sign_up_with_google'];

  String get loginWithGoogle =>
      _localizedValues[locale.toString()]['login_with_google'];

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

  String get anErrorOccurred =>
      _localizedValues[locale.toString()]['an_error_occurred'];

  String get dismiss => _localizedValues[locale.toString()]['dismiss'];

  String get upload => _localizedValues[locale.toString()]['upload'];

  String get save => _localizedValues[locale.toString()]['save'];

  String get public => _localizedValues[locale.toString()]['public'];

  String get refreshComplete =>
      _localizedValues[locale.toString()]['refresh_complete'];

  String get description => _localizedValues[locale.toString()]['description'];

  String get shareSong => _localizedValues[locale.toString()]['share_song'];

  String get reportSong => _localizedValues[locale.toString()]['report_song'];

  String get copyLinkToSong =>
      _localizedValues[locale.toString()]['copy_link_to_song'];

  String get copiedToClipboard =>
      _localizedValues[locale.toString()]['copied_to_clipboard'];

  String get audioLatency =>
      _localizedValues[locale.toString()]['audio_latency'];

  String get milliseconds =>
      _localizedValues[locale.toString()]['milliseconds'];

  String get calibrate =>
      _localizedValues[locale.toString()]['calibrate'];

  String get adjust =>
      _localizedValues[locale.toString()]['adjust'];

  String get trackAdjustment =>
      _localizedValues[locale.toString()]['track_adjustment'];

  String get done =>
      _localizedValues[locale.toString()]['done'];

  String get addAPublicComment =>
      _localizedValues[locale.toString()]['add_a_public_comment'];

  String get viewOriginal =>
      _localizedValues[locale.toString()]['view_original'];

  String get comments =>
      _localizedValues[locale.toString()]['comments'];

  String get comment =>
      _localizedValues[locale.toString()]['comment'];

  String get noComments =>
      _localizedValues[locale.toString()]['no_comments'];

  String get noVideos =>
      _localizedValues[locale.toString()]['no_videos'];

  String get deleteComment =>
      _localizedValues[locale.toString()]['delete_comment'];

  String get addVideo =>
      _localizedValues[locale.toString()]['add_video'];

  String get videoUrlOrId =>
      _localizedValues[locale.toString()]['video_url_or_id'];

  String get pleaseProvideAValue =>
      _localizedValues[locale.toString()]['please_provide_a_value'];

  String get errorInvalidValue =>
      _localizedValues[locale.toString()]['error_invalid_value'];

  String get successfullyAddedVideo =>
      _localizedValues[locale.toString()]['successfully_added_video'];

  String get source =>
      _localizedValues[locale.toString()]['source'];

  String get deleteSong =>
      _localizedValues[locale.toString()]['delete_song'];

  String get parent =>
      _localizedValues[locale.toString()]['parent'];

  String get child =>
      _localizedValues[locale.toString()]['child'];

  String get addAll =>
      _localizedValues[locale.toString()]['add_all'];

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
