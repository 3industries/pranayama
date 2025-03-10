// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'exercise_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(Locale) onLanguageChanged;
  HomeScreen({required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.appTitle),
        actions: [
          PopupMenuButton<Locale>(
            icon: Icon(Icons.language),
            onSelected: onLanguageChanged,
            itemBuilder: (context) => [
              PopupMenuItem(value: Locale('en', ''), child: Text("English")),
              PopupMenuItem(value: Locale('fr', ''), child: Text("Français")),
              PopupMenuItem(value: Locale('it', ''), child: Text("Italiano")),
              PopupMenuItem(value: Locale('ru', ''), child: Text("Русский")),
              PopupMenuItem(value: Locale('zh', ''), child: Text("中文")),
            ],
          )
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ExerciseListScreen()));
          },
          child: Text(localizations.start),
        ),
      ),
    );
  }
}
