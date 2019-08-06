import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const String kAppVersion = '0.0.15+15';
const String kTermsOfServiceURL = 'https://mudeo.app/terms';
const String kPrivacyPolicyURL = 'https://mudeo.app/privacy';
const String kRedditURL = 'https://www.reddit.com/r/mudeo';
const String kTwitterURL = 'https://twitter.com/mudeo_app';
const String kContactEmail = 'contact@mudeo.app';
const String kLatencySamples = 'https://superpowered.com/latency#datatable';

const String kAppleStoreUrl = '';
const String kGoogleStoreUrl = '';

const int kOAuthProviderGoogle = 1;

const String kSharedPrefToken = 'token';
const String kSharedPrefAppVersion = 'app_version';
const String kSharedPrefCameraDirection = 'camera_direction';
const String kSharedPrefGenreId = 'genre_id';
const String kSharedPrefHeadphoneWarning = 'headphone_warning';

const String kCameraDirectionFront = 'front';
const String kCameraDirectionBack = 'back';
const String kCameraDirectionExternal = 'external';

const String kArtistImageHeader = 'header_image';
const String kArtistImageProfile = 'profile_image';

const String kVideoRelationshipParent = 'parent';
const String kVideoRelationshipChild = 'child';

const double kDefaultElevation = 6;
const int kDefaultTrackVolume = 100;
const int kUpdatedAtBufferSeconds = 600;
const int kMillisecondsToRefreshData = 1000 * 60 * 15; // 15 minutes
const int kMillisecondsToRetryData = 1000 * 15; // 10 seconds
const int kMaxRecordsPerApiPage = 100;
const int kMaxTracks = 5;
const int kMaxSongDuration = 3 * 60 * 1000; // 3 minutes
const int kFirstWarningOffset = 10 * 1000; // 10 seconds
const int kSecondWarningOffset = 5 * 1000; // 5 seconds
const int kMinLatencyDelay = -1000;
const int kMaxLatencyDelay = 1000;
const int kMaxCommentLength = 300;

const List<String> kLanguages = [
  'en',
];

const int kTabList = 0;
const int kTabEdit = 1;
const int kTabProfile = 2;

const String kLinkTypeFacebook = 'Facebook';
const String kLinkTypeYouTube = 'YouTube';
const String kLinkTypeInstagram = 'Instagram';
const String kLinkTypeSoundcloud = 'SoundCloud';
const String kLinkTypeTwitch = 'Twitch';
const String kLinkTypeTwitter = 'Twitter';
const String kLinkTypeWebsite = 'Website';
const String kLinkTypeReddit = 'Reddit';

const String kGenreAfrican = 'african';
const String kGenreArabic = 'arabic';
const String kGenreAsian = 'asian';
const String kGenreAvantGarde = 'avant_garde';
const String kGenreBlues = 'blues';
const String kGenreCaribbean = 'caribbean';
const String kGenreClassicalMusic = 'classical_music';
const String kGenreComedy = 'comedy';
const String kGenreCountry = 'country';
const String kGenreEasyListening = 'easy_listening';
const String kGenreElectronic = 'electronic';
const String kGenreFolk = 'folk';
const String kGenreHipHop = 'hip_hop';
const String kGenreJazz = 'jazz';
const String kGenreLatin = 'latin';
const String kGenrePop = 'pop';
const String kGenreRBAndSoul = 'rb_and_soul';
const String kGenreRock = 'rock';
const String kGenreOther = 'other';

const Map<int, String> kGenres = {
  1: kGenreAfrican,
  2: kGenreArabic,
  3: kGenreAsian,
  4: kGenreAvantGarde,
  5: kGenreBlues,
  6: kGenreCaribbean,
  7: kGenreClassicalMusic,
  8: kGenreComedy,
  9: kGenreCountry,
  10: kGenreEasyListening,
  11: kGenreElectronic,
  12: kGenreFolk,
  13: kGenreHipHop,
  14: kGenreJazz,
  15: kGenreLatin,
  16: kGenrePop,
  17: kGenreRBAndSoul,
  18: kGenreRock,
  19: kGenreOther,
};

const Map<int, MaterialAccentColor> kGenreColors = {
  1: Colors.redAccent,
  2: Colors.blueAccent,
  3: Colors.amberAccent,
  4: Colors.cyanAccent,
  5: Colors.blueAccent,
  6: Colors.deepPurpleAccent,
  7: Colors.greenAccent,
  8: Colors.indigoAccent,
  9: Colors.lightBlueAccent,
  10: Colors.lightGreenAccent,
  11: Colors.limeAccent,
  12: Colors.orangeAccent,
  13: Colors.yellowAccent,
  14: Colors.tealAccent,
  15: Colors.pinkAccent,
  16: Colors.tealAccent,
  17: Colors.deepPurpleAccent,
  18: Colors.lightBlueAccent,
  19: Colors.tealAccent,
};

const Map<String, IconData> socialIcons = {
  kLinkTypeFacebook: FontAwesomeIcons.facebook,
  kLinkTypeYouTube: FontAwesomeIcons.youtube,
  kLinkTypeInstagram: FontAwesomeIcons.instagram,
  kLinkTypeTwitch: FontAwesomeIcons.twitch,
  kLinkTypeTwitter: FontAwesomeIcons.twitter,
  kLinkTypeSoundcloud: FontAwesomeIcons.soundcloud,
  kLinkTypeWebsite: FontAwesomeIcons.globe,
};
