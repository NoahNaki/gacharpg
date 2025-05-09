// lib/utils/drop_thresholds.dart

import '../models/gear.dart';
import 'dart:math';

/// The luck thresholds (in percent) at which each rarity tier “opens up.”
const Map<GearRarity, double> dropThresholds = {
  GearRarity.nullTier:     1200.0,
  GearRarity.voidTier:     1000.0,
  GearRarity.transcendant: 900.0,
  GearRarity.godly:        800.0,
  GearRarity.artifact:     700.0,
  GearRarity.fabled:       600.0,
  GearRarity.mythic:       500.0,
  GearRarity.legendary:    400.0,
  GearRarity.epic:         300.0,
  GearRarity.rare:         200.0,
  GearRarity.uncommon:     50.0,
  GearRarity.common:       0.0,
};

/// Compute the live % chances for each rarity given [luck].
Map<GearRarity, double> computeDropChances(double luck) {
  double previous = double.infinity;
  final chances = <GearRarity,double>{};
  dropThresholds.forEach((rar, thr) {
    final upper  = previous;
    final low    = (thr - luck).clamp(0.0, 100.0);
    final high   = (upper.isFinite ? (upper - luck) : 100.0).clamp(0.0, 100.0);
    final pLow   = ((100 - low ) / 100).clamp(0.0, 1.0);
    final pHigh  = upper.isFinite
        ? ((100 - high) / 100).clamp(0.0, 1.0)
        : 0.0;
    chances[rar] = ((pLow - pHigh) * 100).clamp(0.0, 100.0);
    previous = thr;
  });
  return chances;
}

/// Randomly pick one rarity based on [luck], using the same chances.
GearRarity pickRarity(double luck) {
  final chances = computeDropChances(luck);
  final roll = Random().nextDouble() * 100;
  double cum = 0;
  for (var rar in dropThresholds.keys) {
    cum += chances[rar]!;
    if (roll <= cum) return rar;
  }
  return GearRarity.common; // fallback
}
