// lib/services/gear_generator.dart

import 'dart:math';
import 'package:uuid/uuid.dart';
import '../models/gear.dart';
import '../utils/drop_thresholds.dart';

class GearGenerator {
  static final Uuid _uuid = Uuid();
  static final Random _random = Random();

  /// Generates a new Gear object, using player's luck & level to bias rarity & power.
  static Gear generateGear(double luck, int level) {
    // 1) Create a unique ID
    final id = _uuid.v4();

    // 2) Pick a random slot uniformly
    final slot = GearSlot.values[_random.nextInt(GearSlot.values.length)];

    // 3) Pick rarity based on the shared thresholds & current luck
    final rarity = pickRarity(luck);

    // 4) Compute power: base scales with level & rarity tier, plus a luck bonus
    final basePower = level * (rarity.index + 1) * 5;
    final luckBonus = (_random.nextDouble() * level * luck).round();
    final power = basePower + luckBonus;

    // 5) Build a display name
    final niceRarity = rarity.toString().split('.').last;
    final niceSlot   = slot.toString().split('.').last;
    final name = '${niceRarity[0].toUpperCase()}${niceRarity.substring(1)} '
        '${niceSlot[0].toUpperCase()}${niceSlot.substring(1)}';

    // 6) Return the Gear instance
    return Gear(
      id:     id,
      name:   name,
      level:  level,
      rarity: rarity,
      slot:   slot,
      power:  power,
    );
  }
}
