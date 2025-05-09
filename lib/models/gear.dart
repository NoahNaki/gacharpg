
enum GearRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
  mythic,
  fabled,
  artifact,
  godly,
  transcendant,
  voidTier,
  nullTier
}

enum GearSlot { sword, helmet, chestplate, leggings, boots, amulet }

class Gear {
  final String id;
  final String name;
  final int level;
  final GearRarity rarity;
  final GearSlot slot;
  final int power;

  Gear({
    required this.id,
    required this.name,
    required this.level,
    required this.rarity,
    required this.slot,
    required this.power,
  });

  /// XP granted when salvaged
  int get xpValue {
    // Example: base xp = level * 10, plus rarity bonus
    int base = level * 10;
    int rarityBonus = rarity.index * 50;
    return base + rarityBonus;
  }
}