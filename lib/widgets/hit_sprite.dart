// lib/widgets/hit_sprite.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/combat_provider.dart';

/// Displays the mob sprite with a red flash + randomized knockback
/// whenever `lastDamage` is non-null.
class HitSprite extends StatefulWidget {
  final String assetPath;
  final double height;
  const HitSprite({
    Key? key,
    required this.assetPath,
    required this.height,
  }) : super(key: key);

  @override
  _HitSpriteState createState() => _HitSpriteState();
}

class _HitSpriteState extends State<HitSprite> {
  Offset _currentOffset = Offset.zero;
  int? _lastSeenDamage;
  final _rnd = Random();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: context.watch<CombatProvider>(),
      builder: (_, __) {
        final combat = context.read<CombatProvider>();
        final dmg    = combat.lastDamage;
        final isHit  = dmg != null;

        // Detect a new hit and generate a knockback offset once
        if (isHit && dmg != _lastSeenDamage) {
          _lastSeenDamage = dmg;
          final dx = (_rnd.nextDouble() * 20) - 10;   // -10..+10 px
          final dy = -(_rnd.nextDouble() * 20 + 5);   // -5..-25 px
          _currentOffset = Offset(dx, dy);

          // Reset offset after 200ms (but keep the red flash until lastDamage clears)
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) setState(() => _currentOffset = Offset.zero);
          });
        }

        // Draw the sprite at the current offset
        Widget child = Transform.translate(
          offset: _currentOffset,
          child: Image.asset(
            widget.assetPath,
            height: widget.height,
            fit: BoxFit.contain,
          ),
        );

        // If we're in the hit window (lastDamage != null), tint it red
        if (isHit) {
          child = ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.red.withOpacity(0.5),
              BlendMode.srcATop,
            ),
            child: child,
          );
        }

        return child;
      },
    );
  }
}
