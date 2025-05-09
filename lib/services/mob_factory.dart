import 'dart:math';
import '../models/mob.dart';
import '../models/mob_type.dart';

class MobFactory {
  static final _rnd = Random();

  /// Pick a random MobType
  static MobType randomType() {
    final vals = MobType.values;
    return vals[_rnd.nextInt(vals.length)];
  }

  /// Generate a Mob for the given [stage]
  static Mob create(int stage) {
    final type = randomType();
    // Base HP scales quadratically by stage, then by type multiplier
    final baseHp = (50 * stage * stage * type.hpMultiplier).round();
    final reward = (1 * stage * type.hpMultiplier).round();
    return Mob(type: type, maxHp: baseHp, reward: reward);
  }
}
