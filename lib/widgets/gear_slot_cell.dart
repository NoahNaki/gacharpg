import 'package:flutter/material.dart';
import '../models/gear.dart';
import '../utils/constants.dart';

class GearSlotCell extends StatelessWidget {
  final GearSlot slot;
  final Gear? gear;

  const GearSlotCell({
    Key? key,
    required this.slot,
    required this.gear,
  }) : super(key: key);

  /// Returns the asset path for this slot’s icon
  String get assetName {
    switch (slot) {
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

  /// Fallback icon if nothing is equipped
  IconData get placeholderIcon {
    switch (slot) {
      case GearSlot.sword:
        return Icons.gavel;
      case GearSlot.helmet:
        return Icons.security;
      case GearSlot.chestplate:
        return Icons.shield;
      case GearSlot.leggings:
        return Icons.view_stream;
      case GearSlot.boots:
        return Icons.directions_walk;
      case GearSlot.amulet:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    // If gear is equipped, use a gradient; otherwise a flat disabled color box
    final bg = gear != null
        ? rarityGradient(gear!.rarity)
        : LinearGradient(
            colors: [
              Theme.of(context).disabledColor.withOpacity(0.1),
              Theme.of(context).disabledColor.withOpacity(0.3),
            ],
          );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: bg,
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: gear != null
          // Equipped: show the sprite
          ? Image.asset(assetName, width: 40, height: 40)
          // Empty slot: show placeholder icon
          : Icon(placeholderIcon, color: Theme.of(context).disabledColor),
    );
  }
}
