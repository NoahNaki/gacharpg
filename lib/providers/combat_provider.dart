// lib/providers/combat_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/mob.dart';
import '../services/mob_factory.dart';
import 'game_provider.dart';

class CombatProvider with ChangeNotifier {
  final GameProvider gameProvider;

  // ───── Boss timer properties ─────
  /// Total seconds allowed to kill the boss
  final int bossTimeLimit = 20;
  /// Remaining seconds on the boss timer
  int _remainingTime = 20;
  int get remainingTime => _remainingTime;
  Timer? _bossTimer;

  // ───── Damage tick timer ─────
  Timer? _damageTimer;

  // ───── Combat state ─────
  late Mob _currentMob;
  int _killCount = 0;
  bool _isBoss = false;
  int _stage = 1;
  int? _lastDamage;

  CombatProvider({required this.gameProvider}) {
    _spawnMob();
    startCombat();
  }

  // ───── Public getters ─────
  int get killCount => _killCount;
  Mob get currentMob => _currentMob;
  bool get isBoss => _isBoss;
  int get stage => _stage;
  int? get lastDamage => _lastDamage;

  // ───── Start/stop combat ticks ─────
  void startCombat() {
    _damageTimer?.cancel();
    _damageTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void stopCombat() {
    _damageTimer?.cancel();
    _bossTimer?.cancel();
  }

  void _tick() {
    final damage = gameProvider.gearScore;
    _lastDamage = damage;
    _currentMob.takeDamage(damage);
    notifyListeners();

    // Clear lastDamage after hit effect
    Timer(const Duration(milliseconds: 500), () {
      _lastDamage = null;
      notifyListeners();
    });

    if (!_currentMob.isAlive) {
      // Cancel boss timer if boss died
      if (_isBoss) _bossTimer?.cancel();
      _onMobDefeated();
      notifyListeners();
    }
  }

  void _onMobDefeated() {
    gameProvider.refillHammers(_currentMob.reward);
    _killCount++;

    if (_isBoss) {
      // Boss defeated: advance stage
      _advanceStage();
    } else if (_killCount >= 10) {
      // Spawn boss
      _spawnBoss();
    } else {
      // Continue spawning normal mobs
      _spawnMob();
    }
  }

  void _spawnMob() {
    _isBoss = false;
    _currentMob = MobFactory.create(_stage);
  }

  void _spawnBoss() {
    _isBoss = true;
    final base = MobFactory.create(_stage);
    _currentMob = Mob(
      type: base.type,
      maxHp: (base.maxHp * 2.5).round(),
      reward: base.reward * 5,
    );
    _startBossTimer();
  }

  void _advanceStage() {
    _killCount = 0;
    _isBoss = false;
    _stage++;
    _spawnMob();
  }

  void _startBossTimer() {
    _bossTimer?.cancel();
    _remainingTime = bossTimeLimit;
    notifyListeners();

    _bossTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        _remainingTime--;
        notifyListeners();
      } else {
        timer.cancel();
        _onBossTimeExpired();
      }
    });
  }

  void _onBossTimeExpired() {
    // Failure: reset kill count and revert to mob stage
    stopCombat();
    _killCount = 0;
    _isBoss = false;
    _spawnMob();
    notifyListeners();
  }

  void resetCombat() {
    stopCombat();
    _killCount = 0;
    _isBoss = false;
    _stage = 1;
    _lastDamage = null;
    _spawnMob();
    notifyListeners();
  }

  @override
  void dispose() {
    _damageTimer?.cancel();
    _bossTimer?.cancel();
    super.dispose();
  }
}
