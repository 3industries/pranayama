// lib/services/exercise_service.dart
import 'dart:convert';
import 'package:flutter/services.dart'; // Per rootBundle
import 'package:shared_preferences/shared_preferences.dart';
import '../models/breathing_exercise.dart';

class ExerciseService {
  static const String _prefsKey = "user_exercises";

  // Carica gli esercizi salvati dall'utente
  Future<List<BreathingExercise>> getUserExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_prefsKey);
    if (data != null) {
      List<dynamic> jsonList = jsonDecode(data);
      return jsonList.map((e) => BreathingExercise.fromJson(e)).toList();
    }
    return [];
  }

  // Carica gli esercizi predefiniti dal file JSON
  Future<List<BreathingExercise>> loadPredefinedExercises() async {
    final jsonString = await rootBundle.loadString('assets/predefined_exercises.json');
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    if (jsonData.containsKey('exercises')) {
      List<dynamic> exercisesJson = jsonData['exercises'];
      return exercisesJson.map((e) => BreathingExercise.fromJson(e)).toList();
    }
    return [];
  }

  // Restituisce la lista combinata di esercizi (predefiniti + utente)
  Future<List<BreathingExercise>> getAllExercises() async {
    final predefined = await loadPredefinedExercises();
    final userExercises = await getUserExercises();
    return [...predefined, ...userExercises];
  }

  // Salva un nuovo esercizio aggiunto dall'utente
  Future<void> saveUserExercise(BreathingExercise exercise) async {
    final prefs = await SharedPreferences.getInstance();
    List<BreathingExercise> userExercises = await getUserExercises();
    userExercises.add(exercise);
    await prefs.setString(_prefsKey, jsonEncode(userExercises));
  }
}
