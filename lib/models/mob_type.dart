import 'package:flutter/widgets.dart';

enum MobType {
  slime,
  skeleton,
  gargoyle,
  pigWolf,
  theThing,
  tentacool,
  serpent,
  lizzy,
  goober,
  temuGoblin,
  // …add your new types here…
}

extension MobTypeInfo on MobType {
  /// PNG asset path
  String get assetPath {
    switch (this) {
      case MobType.slime:      return 'assets/slime.png';
      case MobType.skeleton:   return 'assets/skeleton.png';
      case MobType.gargoyle:   return 'assets/gargoyle.png';
      case MobType.pigWolf:    return 'assets/pigwolf.png';
      case MobType.theThing:   return 'assets/thething.png';
      case MobType.tentacool:  return 'assets/tentacool.png';
      case MobType.serpent:    return 'assets/serpent.png';
      case MobType.lizzy:      return 'assets/lizzy.png';
      case MobType.goober:     return 'assets/goober.png';
      case MobType.temuGoblin: return 'assets/temugoblin.png';
    }
  }

  /// Base HP multiplier (you can tweak per‐type)
  double get hpMultiplier {
    switch (this) {
      case MobType.slime:      return 0.8;
      case MobType.skeleton:   return 1.0;
      case MobType.gargoyle:   return 1.2;
      case MobType.pigWolf:    return 1.1;
      case MobType.theThing:   return 1.5;
      case MobType.tentacool:  return 0.9;
      case MobType.serpent:    return 1.0;
      case MobType.lizzy:      return 1.0;
      case MobType.goober:     return 0.7;
      case MobType.temuGoblin: return 0.85;
    }
  }
}
