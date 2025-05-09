import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/combat_provider.dart';

class CombatView extends StatelessWidget {
  const CombatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CombatProvider>(
      builder: (_, combat, __) {
        final mob = combat.currentMob;
        if (mob == null) return const SizedBox.shrink();
        final hpPercent = mob.currentHp / mob.maxHp;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Stage: ${combat.stage}'),
            const SizedBox(height: 8),
            Text(combat.isBoss ? 'Boss HP' : 'Mob HP'),
            const SizedBox(height: 4),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 16,
                  child: LinearProgressIndicator(value: hpPercent),
                ),
                if (combat.lastDamage != null)
                  Positioned(
                    top: -20,
                    child: Text(
                      '-${combat.lastDamage}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text('${mob.currentHp} / ${mob.maxHp}'),
            const SizedBox(height: 8),
            Text('Kills: ${combat.killCount}'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: combat.startCombat,
                  child: const Text('Start Battle'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: combat.resetCombat,
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
