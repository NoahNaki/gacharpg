import 'package:flutter/material.dart';
import '../models/gear.dart';

/// A simple color mapping for flat backgrounds
Color rarityColor(GearRarity rarity) {
  switch (rarity) {
    case GearRarity.common:
      return Colors.grey;
    case GearRarity.uncommon:
      return Colors.green;
    case GearRarity.rare:
      return Colors.blue;
    case GearRarity.epic:
      return Colors.purple;
    case GearRarity.legendary:
      return Colors.amber;
    case GearRarity.mythic:
      return Colors.red;
    case GearRarity.fabled:
      return Colors.cyan;
    case GearRarity.artifact:
      return Colors.deepOrange;
    case GearRarity.godly:
      return Colors.deepOrangeAccent;
    case GearRarity.transcendant:
      return Colors.white70;
    case GearRarity.voidTier:
      return Colors.black;
    case GearRarity.nullTier:
      return Colors.white;
  }
}

/// A gradient for equipped slots
LinearGradient rarityGradient(GearRarity rarity) {
  final base = rarityColor(rarity);
  return LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      base,
      base.withOpacity(0.5),
    ],
  );
}
