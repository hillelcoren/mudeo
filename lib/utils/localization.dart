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
      'details': 'Details',
      'favorite': 'Favorite',
      'update': 'Update',
      'headphones': 'Headphones',
      'connected': 'Connected',
      'not_connected': 'Not Connected',
      'aspect_ratio': 'Aspect Ratio',
      'reset_camera': 'Reset Camera',
      'merge': 'Merge',
      'microphone': 'Microphone',
      'camera': 'Camera',
      'reported_comment': 'Comment has been reported',
      'report': 'Report',
      'monitor': 'Monitor',
      'enable_camera': 'Enable Camera',
      'enable_microphone': 'Enable Microphone',
      'primary': 'Primary',
      'enable_downloads': 'Enable Downloads',
      'publish': 'Publish',
      'this_may_take_a_few_minutes': 'This may take a few minutes',
      'guest': 'Guest',
      'download': 'Download',
      'failed_to_render':
          'Failed to create the video on your phone, click \'Save\' to create the video in the cloud.',
      'creating_video': 'Creating Video...',
      'create_video': 'Create Video',
      'leave_dance': 'Leave Dance',
      'leave_song': 'Leave Song',
      'joined_dance': 'Successfully joined dance!',
      'joined_song': 'Successfully joined song!',
      'refresh': 'Refresh',
      'qr_code': 'QR Code',
      'scan': 'Scan',
      'secret': 'Secret',
      'join_song': 'Join Song',
      'join_dance': 'Join Dance',
      'add_friends': 'Add Friends',
      'qr_code_help': 'Share the QR code to add collaborators',
      'start': 'Start',
      'calibration_message':
          'Would you like to run a calibration to check your phone\'s latency/delay?\n\nThe app will record a short test video and then upload it to calculate the results.',
      'calibration_warning':
          'Please check that headphones are not plugged in and it\'s quiet and then press start.',
      'links': 'Links',
      'original': 'Original',
      'fix': 'Fix',
      'blur_image': 'Blur Image',
      'show_image': 'Show Image',
      'your_score_is': 'Your score is',
      'processing': 'Processing',
      'show_details': 'Show Details',
      'score': 'Score',
      'background_music_help':
          'You can play a song in the background to have music to dance to',
      'ballet': 'Ballet',
      'tap': 'Tap',
      'modern': 'Modern',
      'lyrical': 'Lyrical',
      'contemporary': 'Contemporary',
      'style': 'Style',
      'reset_dance': 'Reset Dance',
      'clone_dance': 'Clone Dance',
      'delete_dance': 'Delete Dance',
      'share_dance': 'Share Dance',
      'copy_link_to_dance': 'Copy link to dance',
      'report_dance': 'Report Dance',
      'new_dance': 'New Dance',
      'sure': 'Sure',
      'help_video': 'Help Video',
      'no_thanks': 'No Thanks',
      'welcome_to_the_app': 'Welcome to :name 🥳',
      'want_to_watch_the_video':
          'Would you like to watch a short video explaining how to use the app?',
      'view_on_youtube': 'View on YouTube',
      'view_on_twitter': 'View on Twitter',
      'google_sign_up': 'Google Sign Up',
      'email_sign_up': 'Email Sign Up',
      'email_login': 'Email Login',
      'video_processing_help': 'The video will take a few minutes to process',
      'private_song_link_help':
          'The link will be live once the song is made public',
      'thank_you_for_your_purchase': 'Thank you for your purchase',
      'private': 'Private',
      'past_purchases': 'Past Purchases',
      'private_storage': 'Private Storage',
      'newest': 'Newest',
      'featured': 'Featured',
      'options': 'Options',
      'require_mobile_to_collaborate':
          'Please download the mobile app to collaborate',
      'require_mobile_to_like': 'Please download the mobile app to like',
      'require_mobile_to_report': 'Please download the mobile app to report',
      'require_account_to_collaborate': 'Please login to collaborate',
      'require_account_to_upload': 'Please login to upload',
      'require_account_to_like': 'Please login to like a song',
      'require_account_to_report': 'Please login to report',
      'save_video_to_process_audio': 'Save video to process audio',
      'zoom': 'Zoom',
      'sync': 'Sync',
      'error_video_not_ready':
          'The video is still processing, please try again soon',
      'rendering': 'Rendering',
      'pronounced': 'Pronounced',
      'contact_us': 'Contact Us',
      'backing_track': 'Backing Track',
      'layout': 'Layout',
      'row': 'Row',
      'column': 'Column',
      'grid': 'Grid',
      'clone_song': 'Clone Song',
      'youtube_warning':
          'Note: The YouTube video can be used as a backing track but will not be included in the rendered video.',
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
      'no_saved_videos': 'No Saved Videos',
      'comment': 'Comment',
      'comments': 'Comments',
      'view_original': 'View Original',
      'add_a_public_comment': 'Add a public comment...',
      'reset': 'Reset',
      'track_adjustment': 'Track Adjustment',
      'adjust': 'Adjust',
      'calibrate': 'Calibrate',
      'milliseconds': 'Milliseconds',
      'block_artist': 'Block Artist',
      'copied_to_clipboard': 'Copied to clipboard',
      'copy_link_to_song': 'Copy link to song',
      'copy_link_to_video': 'Copy link to video',
      'report_song': 'Report Song',
      'share_song': 'Share Song',
      'note': 'Note',
      'email_us': 'Email Us',
      'header_image': 'Header Image',
      'profile_image': 'Profile Image',
      'use_google': 'Use Google',
      'use_email': 'Use Email',
      'open_in_browser': 'Open in Browser',
      'open_in_new_tab': 'Open in new tab',
      'remove': 'Remove',
      'remove_video': 'Remove Video',
      'reset_song': 'Reset Song',
      'new_song': 'New Song',
      'logout_app': 'Logout App',
      'logout_from_the_app': 'Logout from the app',
      'version': 'Version',
      'thank_you_for_using_our_app': 'Thank you for using the app!',
      'if_you_like_it': 'If you like it please',
      'tap_here': 'tap here',
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
      'delete_account_warning':
          'WARNING: There is no undo, all data will be permanently erased',
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

  String get backgroundMusicHelp =>
      _localizedValues[locale.toString()]['background_music_help'];

  String get headerImage => _localizedValues[locale.toString()]['header_image'];

  String get profileImage =>
      _localizedValues[locale.toString()]['profile_image'];

  String get emailUs => _localizedValues[locale.toString()]['email_us'];

  String get useGoogle => _localizedValues[locale.toString()]['use_google'];

  String get useEmail => _localizedValues[locale.toString()]['use_email'];

  String get openInBrowser =>
      _localizedValues[locale.toString()]['open_in_browser'];

  String get openInNewTab =>
      _localizedValues[locale.toString()]['open_in_new_tab'];

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

  String get tapHere => _localizedValues[locale.toString()]['tap_here'];

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

  String get deleteAccountWarning =>
      _localizedValues[locale.toString()]['delete_account_warning'];

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

  String get copyLinkToVideo =>
      _localizedValues[locale.toString()]['copy_link_to_video'];

  String get copiedToClipboard =>
      _localizedValues[locale.toString()]['copied_to_clipboard'];

  String get audioLatency =>
      _localizedValues[locale.toString()]['audio_latency'];

  String get milliseconds =>
      _localizedValues[locale.toString()]['milliseconds'];

  String get calibrate => _localizedValues[locale.toString()]['calibrate'];

  String get adjust => _localizedValues[locale.toString()]['adjust'];

  String get trackAdjustment =>
      _localizedValues[locale.toString()]['track_adjustment'];

  String get reset => _localizedValues[locale.toString()]['reset'];

  String get addAPublicComment =>
      _localizedValues[locale.toString()]['add_a_public_comment'];

  String get viewOriginal =>
      _localizedValues[locale.toString()]['view_original'];

  String get comments => _localizedValues[locale.toString()]['comments'];

  String get comment => _localizedValues[locale.toString()]['comment'];

  String get noComments => _localizedValues[locale.toString()]['no_comments'];

  String get noSavedVideos =>
      _localizedValues[locale.toString()]['no_saved_videos'];

  String get deleteComment =>
      _localizedValues[locale.toString()]['delete_comment'];

  String get addVideo => _localizedValues[locale.toString()]['add_video'];

  String get videoUrlOrId =>
      _localizedValues[locale.toString()]['video_url_or_id'];

  String get pleaseProvideAValue =>
      _localizedValues[locale.toString()]['please_provide_a_value'];

  String get errorInvalidValue =>
      _localizedValues[locale.toString()]['error_invalid_value'];

  String get successfullyAddedVideo =>
      _localizedValues[locale.toString()]['successfully_added_video'];

  String get source => _localizedValues[locale.toString()]['source'];

  String get deleteSong => _localizedValues[locale.toString()]['delete_song'];

  String get parent => _localizedValues[locale.toString()]['parent'];

  String get child => _localizedValues[locale.toString()]['child'];

  String get addAll => _localizedValues[locale.toString()]['add_all'];

  String get youtubeWarning =>
      _localizedValues[locale.toString()]['youtube_warning'];

  String get cloneSong => _localizedValues[locale.toString()]['clone_song'];

  String get row => _localizedValues[locale.toString()]['row'];

  String get column => _localizedValues[locale.toString()]['column'];

  String get grid => _localizedValues[locale.toString()]['grid'];

  String get layout => _localizedValues[locale.toString()]['layout'];

  String get backingTrack =>
      _localizedValues[locale.toString()]['backing_track'];

  String get contactUs => _localizedValues[locale.toString()]['contact_us'];

  String get pronounced => _localizedValues[locale.toString()]['pronounced'];

  String get rendering => _localizedValues[locale.toString()]['rendering'];

  String get errorVideoNotReady =>
      _localizedValues[locale.toString()]['error_video_not_ready'];

  String get sync => _localizedValues[locale.toString()]['sync'];

  String get zoom => _localizedValues[locale.toString()]['zoom'];

  String get saveVideoToProcessAudio =>
      _localizedValues[locale.toString()]['save_video_to_process_audio'];

  String get requireAccountToUpload =>
      _localizedValues[locale.toString()]['require_account_to_upload'];

  String get requireAccountToLike =>
      _localizedValues[locale.toString()]['require_account_to_like'];

  String get requireAccountToReport =>
      _localizedValues[locale.toString()]['require_account_to_report'];

  String get requireAccountToCollaborate =>
      _localizedValues[locale.toString()]['require_account_to_collaborate'];

  String get requireMobileToCollaborate =>
      _localizedValues[locale.toString()]['require_mobile_to_collaborate'];

  String get requireMobileToLike =>
      _localizedValues[locale.toString()]['require_mobile_to_like'];

  String get requireMobileToReport =>
      _localizedValues[locale.toString()]['require_mobile_to_report'];

  String get options => _localizedValues[locale.toString()]['options'];

  String get newest => _localizedValues[locale.toString()]['newest'];

  String get featured => _localizedValues[locale.toString()]['featured'];

  String get privateStorage =>
      _localizedValues[locale.toString()]['private_storage'];

  String get pastPurchases =>
      _localizedValues[locale.toString()]['past_purchases'];

  String get private => _localizedValues[locale.toString()]['private'];

  String get thankYouForYourPurchase =>
      _localizedValues[locale.toString()]['thank_you_for_your_purchase'];

  String get privateSongLinkHelp =>
      _localizedValues[locale.toString()]['private_song_link_help'];

  String get videoProcessingHelp =>
      _localizedValues[locale.toString()]['video_processing_help'];

  String get emailLogin => _localizedValues[locale.toString()]['email_login'];

  String get googleSignUp =>
      _localizedValues[locale.toString()]['google_sign_up'];

  String get emailSignUp =>
      _localizedValues[locale.toString()]['email_sign_up'];

  String get viewOnYouTube =>
      _localizedValues[locale.toString()]['view_on_youtube'];

  String get viewOnTwitter =>
      _localizedValues[locale.toString()]['view_on_twitter'];

  String get welcomeToTheApp =>
      _localizedValues[locale.toString()]['welcome_to_the_app'];

  String get sure => _localizedValues[locale.toString()]['sure'];

  String get noThanks => _localizedValues[locale.toString()]['no_thanks'];

  String get wantToWatchTheVideo =>
      _localizedValues[locale.toString()]['want_to_watch_the_video'];

  String get helpVideo => _localizedValues[locale.toString()]['help_video'];

  String get newDance => _localizedValues[locale.toString()]['new_dance'];

  String get shareDance => _localizedValues[locale.toString()]['share_dance'];

  String get copyLinkToDance =>
      _localizedValues[locale.toString()]['copy_link_to_dance'];

  String get reportDance => _localizedValues[locale.toString()]['report_dance'];

  String get style => _localizedValues[locale.toString()]['style'];

  String get deleteDance => _localizedValues[locale.toString()]['delete_dance'];

  String get cloneDance => _localizedValues[locale.toString()]['clone_dance'];

  String get resetDance => _localizedValues[locale.toString()]['reset_dance'];

  String get ballet => _localizedValues[locale.toString()]['ballet'];

  String get tap => _localizedValues[locale.toString()]['tap'];

  String get modern => _localizedValues[locale.toString()]['modern'];

  String get lyrical => _localizedValues[locale.toString()]['lyrical'];

  String get contemporary =>
      _localizedValues[locale.toString()]['contemporary'];

  String get score => _localizedValues[locale.toString()]['score'];

  String get showDetails => _localizedValues[locale.toString()]['show_details'];

  String get processing => _localizedValues[locale.toString()]['processing'];

  String get yourScoreIs =>
      _localizedValues[locale.toString()]['your_score_is'];

  String get blurImage => _localizedValues[locale.toString()]['blur_image'];

  String get showImage => _localizedValues[locale.toString()]['show_image'];

  String get fix => _localizedValues[locale.toString()]['fix'];

  String get original => _localizedValues[locale.toString()]['original'];

  String get links => _localizedValues[locale.toString()]['links'];

  String get start => _localizedValues[locale.toString()]['start'];

  String get calibrationMessage =>
      _localizedValues[locale.toString()]['calibration_message'];

  String get calibrationWarning =>
      _localizedValues[locale.toString()]['calibration_warning'];

  String get qrCodeHelp => _localizedValues[locale.toString()]['qr_code_help'];

  String get addFriends => _localizedValues[locale.toString()]['add_friends'];

  String get joinSong => _localizedValues[locale.toString()]['join_song'];

  String get joinDance => _localizedValues[locale.toString()]['join_dance'];

  String get secret => _localizedValues[locale.toString()]['secret'];

  String get qrCode => _localizedValues[locale.toString()]['qr_code'];

  String get scan => _localizedValues[locale.toString()]['scan'];

  String get refresh => _localizedValues[locale.toString()]['refresh'];

  String get joinedSong => _localizedValues[locale.toString()]['joined_song'];

  String get joinedDance => _localizedValues[locale.toString()]['joined_dance'];

  String get leaveSong => _localizedValues[locale.toString()]['leave_song'];

  String get leaveDance => _localizedValues[locale.toString()]['leave_dance'];

  String get creatingVideo =>
      _localizedValues[locale.toString()]['creating_video'];

  String get failedToRender =>
      _localizedValues[locale.toString()]['failed_to_render'];

  String get download => _localizedValues[locale.toString()]['download'];

  String get guest => _localizedValues[locale.toString()]['guest'];

  String get thisMayTakeAFewMinutes =>
      _localizedValues[locale.toString()]['this_may_take_a_few_minutes'];

  String get createVideo => _localizedValues[locale.toString()]['create_video'];

  String get enableDownloads =>
      _localizedValues[locale.toString()]['enable_downloads'];

  String get publish => _localizedValues[locale.toString()]['publish'];

  String get primary => _localizedValues[locale.toString()]['primary'];

  String get enableCamera =>
      _localizedValues[locale.toString()]['enable_camera'];

  String get enableMicrophone =>
      _localizedValues[locale.toString()]['enable_microphone'];

  String get monitor => _localizedValues[locale.toString()]['monitor'];

  String get report => _localizedValues[locale.toString()]['report'];

  String get microphone => _localizedValues[locale.toString()]['microphone'];

  String get camera => _localizedValues[locale.toString()]['camera'];

  String get merge => _localizedValues[locale.toString()]['merge'];

  String get resetCamera => _localizedValues[locale.toString()]['reset_camera'];

  String get aspectRatio => _localizedValues[locale.toString()]['aspect_ratio'];

  String get reportedComment =>
      _localizedValues[locale.toString()]['reported_comment'];

  String get headphones => _localizedValues[locale.toString()]['headphones'];

  String get connected => _localizedValues[locale.toString()]['connected'];

  String get update => _localizedValues[locale.toString()]['update'];

  String get favorite => _localizedValues[locale.toString()]['favorite'];

  String get details => _localizedValues[locale.toString()]['details'];

  String get notConnected =>
      _localizedValues[locale.toString()]['not_connected'];

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
