// lib/widgets/gear_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/gear.dart';
import '../providers/game_provider.dart';
import '../utils/rarity_color.dart';

class GearCard extends StatelessWidget {
  final Gear gear;
  const GearCard({Key? key, required this.gear}) : super(key: key);

  /// Returns the asset path for this gear slot’s icon
  String get _assetPath {
    switch (gear.slot) {
      case GearSlot.sword:
        return 'assets/sword.png';
      case GearSlot.helmet:
        return 'assets/helmet.png';
      case GearSlot.chestplate:
        return 'assets/chestpiece.png';
      case GearSlot.leggings:
        return 'assets/pants.png';
      case GearSlot.boots:
        return 'assets/boots.png';
      case GearSlot.amulet:
        return 'assets/amulet.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor      = rarityColor(gear.rarity);
    final glowGradient = rarityGradient(gear.rarity);
    final rarityStr    = gear.rarity.toString().split('.').last;
    final slotStr      = gear.slot.toString().split('.').last;
    final niceRarity   = '${rarityStr[0].toUpperCase()}${rarityStr.substring(1)}';
    final niceSlot     = '${slotStr[0].toUpperCase()}${slotStr.substring(1)}';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        gradient: glowGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: bgColor.withOpacity(0.6), blurRadius: 12, spreadRadius: 2),
        ],
      ),
      child: Card(
        color: bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.none,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1) Slot icon
              Image.asset(
                _assetPath,
                width: 64,
                height: 64,
                fit: BoxFit.contain,
              ),

              const SizedBox(width: 16),

              // 2) Gear info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$niceRarity $niceSlot',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Power: ${gear.power}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level: ${gear.level}',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // 3) Equip & Salvage buttons
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, size: 24, color: Colors.white),
                    tooltip: 'Equip',
                    onPressed: () {
                      context.read<GameProvider>().equipGear();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.gavel, size: 24, color: Colors.white),
                    tooltip: 'Salvage',
                    onPressed: () {
                      context.read<GameProvider>().salvageGear();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
