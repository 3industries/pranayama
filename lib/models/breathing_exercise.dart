import 'breathing_phase.dart';

class BreathingExercise {
  String name;
  int inhale;
  int hold;
  int exhale;
  int rounds;
  int inhaleIncrement;
  int holdIncrement;
  int exhaleIncrement;
  String description;
  bool alternateNostril;
  bool retentionAfterInhalation;
  List<BreathingPhase>? customSequence;

  BreathingExercise({
    required this.name,
    required this.inhale,
    required this.hold,
    required this.exhale,
    required this.rounds,
    required this.inhaleIncrement,
    required this.holdIncrement,
    required this.exhaleIncrement,
    required this.description,
    required this.alternateNostril,
    required this.retentionAfterInhalation,
    this.customSequence,
  });

  // Calcola la durata totale dell'esercizio
  int get duration => (inhale + hold + exhale) * rounds;

  Map<String, dynamic> toJson() => {
    'name': name,
    'inhale': inhale,
    'hold': hold,
    'exhale': exhale,
    'rounds': rounds,
    'inhaleIncrement': inhaleIncrement,
    'holdIncrement': holdIncrement,
    'exhaleIncrement': exhaleIncrement,
    'description': description,
    'alternateNostril': alternateNostril,
    'retentionAfterInhalation': retentionAfterInhalation,
    if (customSequence != null)
      'customSequence': customSequence!.map((phase) => phase.toJson()).toList(),
  };

  factory BreathingExercise.fromJson(Map<String, dynamic> json) {
    List<BreathingPhase>? sequence;
    if (json.containsKey('customSequence')) {
      var list = json['customSequence'] as List;
      sequence = list.map((e) => BreathingPhase.fromJson(e)).toList();
    }
    return BreathingExercise(
      name: json['name'],
      inhale: json['inhale'],
      hold: json['hold'],
      exhale: json['exhale'],
      rounds: json['rounds'],
      inhaleIncrement: json['inhaleIncrement'],
      holdIncrement: json['holdIncrement'],
      exhaleIncrement: json['exhaleIncrement'],
      description: json['description'] ?? "",
      alternateNostril: json['alternateNostril'] ?? false,
      retentionAfterInhalation: json['retentionAfterInhalation'] ?? true,
      customSequence: sequence,
    );
  }
}
