// lib/providers/game_provider.dart

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/gear.dart';
import '../models/player.dart';
import '../services/gear_generator.dart';
import '../utils/drop_thresholds.dart';

class GameProvider with ChangeNotifier {
  final Player _player = Player();
  final GearGenerator _gearGen = GearGenerator();

  Gear? currentGear;
  bool _rollCooldown = false;
  bool autoRolling = false;
  bool autoRollingAndEquipping = false;

  // Basic stats
  int get hammers    => _player.hammers;
  double get luck    => _player.luck;
  int get xp         => _player.xp;
  int get level      => _player.level;
  int get xpToNext   => _player.xpToNext;
  Map<GearSlot, Gear?> get equipped => _player.equipment;

  // Derived stats
  int get gearScore => _player.equipment.values
      .where((g) => g != null)
      .fold(0, (sum, g) => sum + (g!.power));

  bool get canRoll   => !_rollCooldown && _player.hammers > 0;
  bool get isRolling => _rollCooldown;

  /// Roll a new piece of gear (with 1s cooldown)
  void rollGear() {
    if (!canRoll) return;
    _startRollCooldown();
    _player.hammers--;
    currentGear = GearGenerator.generateGear(_player.luck, _player.level);
    notifyListeners();
  }

  void _startRollCooldown() {
    _rollCooldown = true;
    Timer(const Duration(seconds: 1), () {
      _rollCooldown = false;
      notifyListeners();
    });
  }

  /// Salvage current gear for XP + slight luck bump
  void salvageGear() {
    if (currentGear == null) return;
    _player.xp += currentGear!.xpValue;
    while (_player.xp >= _player.xpToNext) {
      _player.xp -= _player.xpToNext;
      _player.level++;
    }
    _player.luck += 0.5;
    currentGear = null;
    notifyListeners();
  }

  /// Equip current gear into its slot
  void equipGear() {
    if (currentGear == null) return;
    _player.equipment[currentGear!.slot] = currentGear;
    currentGear = null;
    notifyListeners();
  }

  /// Auto‑roll until you get a strictly better item for its slot
  void toggleAutoRollUntilBetter() {
    autoRolling = !autoRolling;
    notifyListeners();
    if (autoRolling) _runAutoRollUntilBetter();
  }

  Future<void> _runAutoRollUntilBetter() async {
    while (_player.hammers > 0 && autoRolling) {
      rollGear();
      await Future.delayed(const Duration(seconds: 1));
      final gear = currentGear!;
      final equippedNow = _player.equipment[gear.slot];
      if (equippedNow == null || gear.power > equippedNow.power) break;

      // Otherwise salvage and continue
      _player.xp += gear.xpValue;
      while (_player.xp >= _player.xpToNext) {
        _player.xp -= _player.xpToNext;
        _player.level++;
      }
      _player.luck += 0.2;
      currentGear = null;
      notifyListeners();
    }
    autoRolling = false;
    notifyListeners();
  }

  /// Auto‑roll and auto‑equip any upgrade
  void toggleAutoRollAndEquip() {
    autoRollingAndEquipping = !autoRollingAndEquipping;
    notifyListeners();
    if (autoRollingAndEquipping) _runAutoRollAndEquip();
  }

  Future<void> _runAutoRollAndEquip() async {
    while (_player.hammers > 0 && autoRollingAndEquipping) {
      rollGear();
      await Future.delayed(const Duration(seconds: 1));
      final gear = currentGear!;
      final equippedNow = _player.equipment[gear.slot];
      if (equippedNow == null || gear.power > equippedNow.power) {
        _player.equipment[gear.slot] = gear;
        currentGear = null;
      } else {
        _player.xp += gear.xpValue;
        while (_player.xp >= _player.xpToNext) {
          _player.xp -= _player.xpToNext;
          _player.level++;
        }
        _player.luck += 0.2;
        currentGear = null;
      }
      notifyListeners();
    }
    autoRollingAndEquipping = false;
    notifyListeners();
  }

  /// Refill hammers
  void refillHammers([int amount = 10]) {
    _player.hammers += amount;
    notifyListeners();
  }

  /// Live drop‑chance percentages based on shared thresholds
  Map<GearRarity, double> get dropChances =>
      computeDropChances(_player.luck);
}
