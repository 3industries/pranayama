// lib/models/breathing_phase.dart
class BreathingPhase {
  String phase; // "inhale", "hold", "exhale"
  int duration;

  BreathingPhase({required this.phase, required this.duration});

  factory BreathingPhase.fromJson(Map<String, dynamic> json) {
    return BreathingPhase(
      phase: json['phase'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() => {
    'phase': phase,
    'duration': duration,
  };
}
