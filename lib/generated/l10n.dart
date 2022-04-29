// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `User authorization failed`
  String get welcomeStatusErrorOnAuth {
    return Intl.message(
      'User authorization failed',
      name: 'welcomeStatusErrorOnAuth',
      desc: '',
      args: [],
    );
  }

  /// `Weibo SDK initialization failed`
  String get welcomeStatusErrorOnInit {
    return Intl.message(
      'Weibo SDK initialization failed',
      name: 'welcomeStatusErrorOnInit',
      desc: '',
      args: [],
    );
  }

  /// `Starting up application...`
  String get welcomeStatusStarting {
    return Intl.message(
      'Starting up application...',
      name: 'welcomeStatusStarting',
      desc: '',
      args: [],
    );
  }

  /// `Weibo@Flow`
  String get homeTitle {
    return Intl.message(
      'Weibo@Flow',
      name: 'homeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Retweeted Weibo`
  String get contentRetweetText {
    return Intl.message(
      'Retweeted Weibo',
      name: 'contentRetweetText',
      desc: '',
      args: [],
    );
  }

  /// `Just Now`
  String get contentJustNow {
    return Intl.message(
      'Just Now',
      name: 'contentJustNow',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get contentToday {
    return Intl.message(
      'Today',
      name: 'contentToday',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get contentYesterday {
    return Intl.message(
      'Yesterday',
      name: 'contentYesterday',
      desc: '',
      args: [],
    );
  }

  /// `Login again`
  String get dialogButtonReLogin {
    return Intl.message(
      'Login again',
      name: 'dialogButtonReLogin',
      desc: '',
      args: [],
    );
  }

  /// `Woops!`
  String get dialogErrorTitle {
    return Intl.message(
      'Woops!',
      name: 'dialogErrorTitle',
      desc: '',
      args: [],
    );
  }

  /// `Looks like we are having network issue. But don't worry lets try again!`
  String get dialogErrorNormal {
    return Intl.message(
      'Looks like we are having network issue. But don\'t worry lets try again!',
      name: 'dialogErrorNormal',
      desc: '',
      args: [],
    );
  }

  /// `Your account access token seems expired. Please login again.`
  String get dialogErrorTokenExpired {
    return Intl.message(
      'Your account access token seems expired. Please login again.',
      name: 'dialogErrorTokenExpired',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
