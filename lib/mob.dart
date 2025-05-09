
class Mob {
  final int maxHp;
  final int reward;
  int currentHp;

  Mob({required this.maxHp, required this.reward}) : currentHp = maxHp;

  bool get isAlive => currentHp > 0;

  get hp => this.currentHp;

  void takeDamage(int damage) {
    currentHp = (currentHp - damage).clamp(0, maxHp);
  }

  void reset() {
    currentHp = maxHp;
  }
}
