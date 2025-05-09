// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:gear_roller_auto_battler/models/mob_type.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/game_provider.dart';
import '../providers/combat_provider.dart';
import '../widgets/hit_sprite.dart';
import '../widgets/damage_indicator.dart';
import '../widgets/screen_shake.dart';
import '../widgets/gear_slot_cell.dart';
import '../widgets/gear_popup.dart';
import '../widgets/gear_drop_animation.dart';
import '../widgets/banner_popup.dart';
import '../models/gear.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game   = context.watch<GameProvider>();
    final combat = context.watch<CombatProvider>();
    final size   = MediaQuery.of(context).size;
    final combatH = size.height * 0.35;
    final spritePath = combat.currentMob.type.assetPath;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ─── Combat area ────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: combatH,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset('assets/dungeon_room.png', fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: ScreenShake(
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 0, left: 0, right: 0,
                            child: HitSprite(
                              assetPath: spritePath,
                              height: combatH * 0.5,
                            ),
                          ),
                          Align(
                            alignment: const Alignment(0.4, -0.1),
                            child: const DamageIndicator(),
                          ),
                          Align(
                            alignment: const Alignment(0, -0.7),
                            child: Container(
                              width: size.width * 0.4,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade900.withOpacity(0.6),
                                border: Border.all(color: Colors.grey.shade700),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.white),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Stage: ${combat.stage}',
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 6),
                                    SizedBox(
                                      height: 20,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: Stack(
                                          children: [
                                            LinearProgressIndicator(
                                              value: combat.currentMob.hp / combat.currentMob.maxHp,
                                              color: Colors.red,
                                              backgroundColor: Colors.white24,
                                              minHeight: 20,
                                            ),
                                            Center(
                                              child: Text(
                                                '${combat.currentMob.hp}/${combat.currentMob.maxHp}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (combat.isBoss) ...[
                                      SizedBox(
                                        height: 20,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Stack(
                                            children: [
                                              LinearProgressIndicator(
                                                value: combat.remainingTime / combat.bossTimeLimit,
                                                backgroundColor: Colors.grey.shade800,
                                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.yellow),
                                                minHeight: 20,
                                              ),
                                              Center(
                                                child: Text(
                                                  '${combat.remainingTime}s',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                    ] else ...[
                                      const SizedBox(height: 6),
                                    ],
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text('💀', style: TextStyle(fontSize: 16)),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${combat.killCount}/10',
                                          style: const TextStyle(fontSize: 12, color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ─── Rolling & gear UI ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hammers: ${game.hammers}', style: GoogleFonts.roboto()),
                    Text('Luck: ${game.luck.toStringAsFixed(2)}%', style: GoogleFonts.roboto()),
                    const SizedBox(height: 8),
                    Text('Level: ${game.level}', style: GoogleFonts.roboto()),
                    LinearProgressIndicator(value: game.xp / game.xpToNext),
                    const SizedBox(height: 16),

                    // ─── All your FABs (including Drop Chances) ───────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: game.isRolling ? null : game.rollGear,
                          tooltip: 'Roll Gear',
                          child: const Icon(Icons.casino),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          onPressed: () => game.toggleAutoRollUntilBetter(),
                          tooltip: 'Auto Roll until Better',
                          backgroundColor: game.autoRolling ? Colors.green : null,
                          child: const Icon(Icons.repeat),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          onPressed: () => game.toggleAutoRollAndEquip(),
                          tooltip: 'Auto Roll + Equip',
                          backgroundColor: game.autoRollingAndEquipping ? Colors.green : null,
                          child: const Icon(Icons.upgrade),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          onPressed: () => game.refillHammers(),
                          tooltip: 'Refill Hammers',
                          child: const Icon(Icons.add),
                        ),
                        const SizedBox(width: 12),
                        FloatingActionButton(
                          heroTag: 'dropChances',
                          tooltip: 'Drop Chances',
                          child: const Icon(Icons.search),
                          onPressed: () {
                            final chances = context.read<GameProvider>().dropChances;
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Drop Chances'),
                                content: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: size.height * 0.6,
                                    maxWidth: 300,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Table(
                                      columnWidths: const {
                                        0: FlexColumnWidth(),
                                        1: IntrinsicColumnWidth(),
                                      },
                                      children: chances.entries.map((e) {
                                        final label = e.key.toString().split('.').last;
                                        final pct   = '${e.value.toStringAsFixed(2)}%';
                                        return TableRow(children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Text(label),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Text(pct, textAlign: TextAlign.right),
                                          ),
                                        ]);
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Close'),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ─── Gear drop animation ───────────────────────────────
                    if (game.currentGear != null) ...[
                      GearDropAnimation(gear: game.currentGear!),
                      const SizedBox(height: 16),
                    ],

                    const Divider(),
                    const SizedBox(height: 10),
                    Text(
                      "Equipped Gear",
                      style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: GearSlot.values.map((slot) {
                        final g = game.equipped[slot];
                        return GestureDetector(
                          onTap: () => g != null ? showGearPopup(context, g) : null,
                          child: GearSlotCell(slot: slot, gear: g),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
