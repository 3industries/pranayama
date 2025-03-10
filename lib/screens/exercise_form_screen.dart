// lib/screens/exercise_form_screen.dart
import 'package:flutter/material.dart';
import '../models/breathing_exercise.dart';
import '../services/exercise_service.dart';

class ExerciseFormScreen extends StatefulWidget {
  @override
  _ExerciseFormScreenState createState() => _ExerciseFormScreenState();
}

class _ExerciseFormScreenState extends State<ExerciseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _inhaleController = TextEditingController();
  final _holdController = TextEditingController();
  final _exhaleController = TextEditingController();
  final _roundsController = TextEditingController();
  final _inhaleIncrementController = TextEditingController();
  final _holdIncrementController = TextEditingController();
  final _exhaleIncrementController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _alternateNostril = false;
  bool _retentionAfterInhalation = true;

  final ExerciseService _service = ExerciseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuovo Esercizio")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Nome Esercizio"),
                validator: (value) => value!.isEmpty ? "Inserisci un nome" : null,
              ),
              TextFormField(
                controller: _inhaleController,
                decoration: InputDecoration(labelText: "Inspirazione (s)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Inserisci il tempo" : null,
              ),
              TextFormField(
                controller: _holdController,
                decoration: InputDecoration(labelText: "Ritenzione (s)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Inserisci il tempo" : null,
              ),
              TextFormField(
                controller: _exhaleController,
                decoration: InputDecoration(labelText: "Espirazione (s)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Inserisci il tempo" : null,
              ),
              TextFormField(
                controller: _roundsController,
                decoration: InputDecoration(labelText: "Numero di round"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Inserisci il numero di round" : null,
              ),
              TextFormField(
                controller: _inhaleIncrementController,
                decoration: InputDecoration(labelText: "Incremento/diminuzione inspirazione (s)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Inserisci il valore" : null,
              ),
              TextFormField(
                controller: _holdIncrementController,
                decoration: InputDecoration(labelText: "Incremento/diminuzione ritenzione (s)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Inserisci il valore" : null,
              ),
              TextFormField(
                controller: _exhaleIncrementController,
                decoration: InputDecoration(labelText: "Incremento/diminuzione espirazione (s)"),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? "Inserisci il valore" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Descrizione (suggerimenti e tecnica)"),
                maxLines: 3,
              ),
              SwitchListTile(
                title: Text("Passaggio tra narici"),
                value: _alternateNostril,
                onChanged: (value) {
                  setState(() {
                    _alternateNostril = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text("Ritenzione dopo l'inalazione (altrimenti dopo l'espulsione)"),
                value: _retentionAfterInhalation,
                onChanged: (value) {
                  setState(() {
                    _retentionAfterInhalation = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final exercise = BreathingExercise(
                      name: _nameController.text,
                      inhale: int.parse(_inhaleController.text),
                      hold: int.parse(_holdController.text),
                      exhale: int.parse(_exhaleController.text),
                      rounds: int.parse(_roundsController.text),
                      inhaleIncrement: int.parse(_inhaleIncrementController.text),
                      holdIncrement: int.parse(_holdIncrementController.text),
                      exhaleIncrement: int.parse(_exhaleIncrementController.text),
                      description: _descriptionController.text,
                      alternateNostril: _alternateNostril,
                      retentionAfterInhalation: _retentionAfterInhalation,
                    );
                    await _service.saveUserExercise(exercise);
                    Navigator.pop(context);
                  }
                },
                child: Text("Salva Esercizio"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
