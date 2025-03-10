// lib/screens/timer_screen.dart
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import '../models/breathing_exercise.dart';
import '../models/breathing_phase.dart';
import '../l10n/app_localizations.dart';

class TimerScreen extends StatefulWidget {
  final BreathingExercise exercise;
  TimerScreen({required this.exercise});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final AudioPlayer _player = AudioPlayer();

  int currentRound = 0;
  late List<String> phases; // Usato se non si imposta una customSequence
  int phaseIndex = 0;
  int timeLeft = 0;
  int? currentPhaseTotalTime;
  Timer? _timer;

  // Lista delle fasi personalizzate, se definita
  List<BreathingPhase>? customSequence;

  @override
  void initState() {
    super.initState();
    currentRound = 0;
    phaseIndex = 0;
    _setupAnimation();

    if (widget.exercise.customSequence != null && widget.exercise.customSequence!.isNotEmpty) {
      customSequence = widget.exercise.customSequence;
    } else {
      if (widget.exercise.retentionAfterInhalation) {
        phases = ["Inspirazione", "Ritenzione", "Espirazione"];
      } else {
        phases = ["Inspirazione", "Espirazione", "Ritenzione"];
      }
    }
    _startPhase();
  }

  void _setupAnimation() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  int _getCurrentPhaseTime() {
    if (customSequence != null) {
      return customSequence![phaseIndex].duration;
    } else {
      int baseTime;
      int increment;
      switch (phases[phaseIndex]) {
        case "Inspirazione":
          baseTime = widget.exercise.inhale;
          increment = widget.exercise.inhaleIncrement;
          break;
        case "Ritenzione":
          baseTime = widget.exercise.hold;
          increment = widget.exercise.holdIncrement;
          break;
        case "Espirazione":
        default:
          baseTime = widget.exercise.exhale;
          increment = widget.exercise.exhaleIncrement;
          break;
      }
      return baseTime + (currentRound * increment);
    }
  }

  String _getCurrentPhaseName() {
    if (customSequence != null) {
      String phaseKey = customSequence![phaseIndex].phase;
      return phaseKey == "inhale"
          ? "Inspirazione"
          : phaseKey == "hold"
          ? "Ritenzione"
          : "Espirazione";
    } else {
      return phases[phaseIndex];
    }
  }

  Color getPhaseColor() {
    String phase = _getCurrentPhaseName();
    switch (phase) {
      case "Inspirazione":
        return Colors.lightBlueAccent;
      case "Ritenzione":
        return Colors.amberAccent;
      case "Espirazione":
        return Colors.pinkAccent;
      default:
        return Colors.blueAccent;
    }
  }

  String getCurrentNostril() {
    return (currentRound % 2 == 0) ? "Sinistra" : "Destra";
  }

  Future<void> _playSound(String phase) async {
    String path = "assets/sounds/${phase.toLowerCase()}.mp3";
    await _player.play(AssetSource(path));
  }

  void _startPhase() {
    int phaseTime = _getCurrentPhaseTime();
    setState(() {
      timeLeft = phaseTime;
      currentPhaseTotalTime = phaseTime;
    });
    String currentPhase = _getCurrentPhaseName();
    _playSound(currentPhase);

    if (currentPhase == "Inspirazione") {
      _controller.duration = Duration(seconds: phaseTime);
      _controller.forward(from: 0.0);
    } else if (currentPhase == "Espirazione") {
      _controller.duration = Duration(seconds: phaseTime);
      _controller.reverse(from: 1.0);
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        _timer?.cancel();
        if (customSequence != null) {
          if (phaseIndex < customSequence!.length - 1) {
            setState(() {
              phaseIndex++;
            });
            _startPhase();
          } else {
            _nextRound();
          }
        } else {
          if (phaseIndex < phases.length - 1) {
            setState(() {
              phaseIndex++;
            });
            _startPhase();
          } else {
            _nextRound();
          }
        }
      }
    });
  }

  void _nextRound() {
    if (currentRound < widget.exercise.rounds - 1) {
      setState(() {
        currentRound++;
        phaseIndex = 0;
      });
      _startPhase();
    } else {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final localizations = AppLocalizations.of(context);
        return AlertDialog(
          title: Text("Completato!"),
          content: Text("Hai completato tutti i round."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(localizations.stop),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    String currentPhase = _getCurrentPhaseName();
    double progress = currentPhaseTotalTime != null ? (timeLeft / currentPhaseTotalTime!) : 0.0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: Text(widget.exercise.name)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Round ${currentRound + 1} di ${widget.exercise.rounds}", style: TextStyle(fontSize: 20)),
              if (widget.exercise.alternateNostril)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    "Utilizza la narice ${getCurrentNostril()}",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                  ),
                ),
              if (widget.exercise.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.exercise.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 10),
              Text(
                currentPhase == "Inspirazione"
                    ? localizations.inhale
                    : currentPhase == "Ritenzione"
                    ? localizations.hold
                    : localizations.exhale,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(getPhaseColor()),
                    ),
                  ),
                  Text(
                    "${(progress * 100).toInt()}%",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _timer?.cancel();
                  _controller.stop();
                  Navigator.pop(context);
                },
                child: Text(localizations.stop),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
