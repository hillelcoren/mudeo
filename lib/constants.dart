import 'package:flutter/material.dart';

const String kAppVersion = '0.0.1';
const String kAppURL = 'https://mudeo.app/api';
const String kTermsOfServiceURL = 'https://mudeo.app';
const String kPrivacyPolicyURL = 'https://mudeo.app';

const String kAppleStoreUrl = '';
const String kGoogleStoreUrl = '';

const String kSharedPrefToken = 'token';
const String kSharedPrefEmail = 'email';
const String kSharedPrefAppVersion = 'app_version';

const int kUpdatedAtBufferSeconds = 600;
const int kMillisecondsToRefreshData = 1000 * 60 * 15; // 15 minutes
const int kMaxRecordsPerApiPage = 100;

const List<String> kLanguages = [
  'en',
];

const String kLinkTypeFacebook = 'Facebook';
const String kLinkTypeYouTube = 'YouTube';
const String kLinkTypeInstagram = 'Instagram';
const String kLinkTypeSoundCloud = 'SoundCloud';
const String kLinkTypeTwitch = 'Twitch';
const String kLinkTypeTwitter = 'Twitter';
const String kLinkTypeWebsite = 'Website';

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
