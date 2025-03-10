// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(PranayamaApp());
}

class PranayamaApp extends StatefulWidget {
  @override
  _PranayamaAppState createState() => _PranayamaAppState();
}

class _PranayamaAppState extends State<PranayamaApp> {
  Locale _locale = Locale('en', ''); // Lingua predefinita

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('selected_language');
    if (languageCode != null) {
      setState(() {
        _locale = Locale(languageCode, '');
      });
    }
  }

  Future<void> _changeLanguage(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', locale.languageCode);
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: [
        Locale('en', ''),
        Locale('fr', ''),
        Locale('it', ''),
        Locale('ru', ''),
        Locale('zh', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomeScreen(onLanguageChanged: _changeLanguage),
    );
  }
}
