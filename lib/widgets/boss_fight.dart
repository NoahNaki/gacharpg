import 'dart:async';
import 'package:flutter/material.dart';

class BossFightWidget extends StatefulWidget {
  final int totalTimeSeconds;
  // callback when boss is killed
  final VoidCallback onBossKilled;
  // callback when time expires without a kill
  final VoidCallback onTimeExpired;

  const BossFightWidget({
    Key? key,
    required this.totalTimeSeconds,
    required this.onBossKilled,
    required this.onTimeExpired,
  }) : super(key: key);

  @override
  _BossFightWidgetState createState() => _BossFightWidgetState();
}

class _BossFightWidgetState extends State<BossFightWidget> {
  late Timer _timer;
  late int _remainingSeconds;
  bool _bossDead = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _remainingSeconds = widget.totalTimeSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_bossDead) {
        t.cancel();
        return;
      }
      setState(() {
        _remainingSeconds--;
      });
      if (_remainingSeconds <= 0) {
        t.cancel();
        if (!_bossDead) {
          widget.onTimeExpired();
        }
      }
    });
  }

  /// Call this when your game logic detects that the boss has been killed
  void notifyBossKilled() {
    if (!_bossDead) {
      _bossDead = true;
      _timer.cancel();
      widget.onBossKilled();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double progress =
    (_remainingSeconds / widget.totalTimeSeconds).clamp(0.0, 1.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Your existing boss/mob HP bar goes here:
        // e.g. BossHPBar(...),
        Container(
          height: 16,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          color: Colors.black87,
          alignment: Alignment.centerLeft,
          child: Text(
            'Time Left: $_remainingSeconds s',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),

        // The yellow timer bar:
        SizedBox(
          height: 8,
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade800,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
          ),
        ),

        // ... any other boss UI
      ],
    );
  }
}
