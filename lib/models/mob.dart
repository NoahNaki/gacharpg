import 'mob_type.dart';

class Mob {
  final MobType type;
  final int maxHp;
  final int reward;
  int hp;

  Mob({
    required this.type,
    required this.maxHp,
    required this.reward,
  }) : hp = maxHp;

  bool get isAlive => hp > 0;

  get currentHp => currentHp;
  void takeDamage(int dmg) {
    hp = (hp - dmg).clamp(0, maxHp);
  }
}
