// lib/l10n/app_localizations.dart
import 'package:flutter/material.dart';
import 'app_localizations_messages.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  String get appTitle => localizedStrings[locale.languageCode]?['appTitle'] ?? 'Pranayama App';
  String get start => localizedStrings[locale.languageCode]?['start'] ?? 'Start';
  String get inhale => localizedStrings[locale.languageCode]?['inhale'] ?? 'Inhale';
  String get hold => localizedStrings[locale.languageCode]?['hold'] ?? 'Hold';
  String get exhale => localizedStrings[locale.languageCode]?['exhale'] ?? 'Exhale';
  String get stop => localizedStrings[locale.languageCode]?['stop'] ?? 'Stop';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => ['en', 'fr', 'it', 'ru', 'zh'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
