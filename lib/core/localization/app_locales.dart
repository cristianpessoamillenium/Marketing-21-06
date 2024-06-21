import 'dart:ui';

import 'package:timeago/timeago.dart' as timeago;

class AppLocales {
  static Locale portugues = const Locale('pt', 'BR');
  static Locale english = const Locale('en', 'US');
  static Locale arabic = const Locale('ar', 'SA');
  static Locale spanish = const Locale('es', 'ES');
  static Locale hindi = const Locale('hi', 'IN');
  static Locale turkish = const Locale('tr', 'TR');

  static List<Locale> supportedLocales = [
    portugues,
    english,
    arabic,
    turkish,
    spanish,
    hindi,
  ];

  /// Returns a formatted version of language
  /// if nothing is present than it will pass the locale to a string
  static String formattedLanguageName(Locale locale) {
    if (locale == portugues) {
      return 'Português';
    } else if (locale == english) {
      return 'English';
    } else if (locale == arabic) {
      return 'عربي';
    } else if (locale == spanish) {
      return 'Español';
    } else if (locale == hindi) {
      return 'हिन्दी';
    } else if (locale == turkish) {
      return 'Türkçe';
    } else {
      return locale.countryCode.toString();
    }
  }

  /// If you want custom messages on time ago (eg. a minute ago, a while ago)
  /// you can modify the below code, otherwise don't modify it unless necesarry
  static void setLocaleMessages() {
    timeago.setLocaleMessages(portugues.toString(), timeago.PtBrMessages());
    timeago.setLocaleMessages(english.toString(), timeago.EnMessages());
    timeago.setLocaleMessages(spanish.toString(), timeago.EsMessages());
    timeago.setLocaleMessages(arabic.toString(), timeago.ArMessages());
    timeago.setLocaleMessages(turkish.toString(), timeago.TrMessages());
  }
}
