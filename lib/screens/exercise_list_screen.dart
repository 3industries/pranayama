// lib/screens/exercise_list_screen.dart
import 'package:flutter/material.dart';
import '../models/breathing_exercise.dart';
import '../services/exercise_service.dart';
import 'exercise_form_screen.dart';
import 'timer_screen.dart';
import '../l10n/app_localizations.dart';

class ExerciseListScreen extends StatefulWidget {
  @override
  _ExerciseListScreenState createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  final ExerciseService _service = ExerciseService();
  List<BreathingExercise> _exercises = [];

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  void _loadExercises() async {
    List<BreathingExercise> exercises = await _service.getAllExercises();
    setState(() {
      _exercises = exercises;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(localizations.appTitle)),
      body: ListView.builder(
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          final exercise = _exercises[index];
          return ListTile(
            title: Text(exercise.name),
            subtitle: Text(
                "Inspira: ${exercise.inhale}s, Ritenzione: ${exercise.hold}s, Espira: ${exercise.exhale}s, Round: ${exercise.rounds}"),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimerScreen(exercise: exercise)),
                );
              },
              child: Text(localizations.start),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExerciseFormScreen()),
          );
          _loadExercises();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
