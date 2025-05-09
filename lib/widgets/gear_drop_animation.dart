import 'package:flutter/material.dart';
import '../models/gear.dart';
import 'gear_card.dart';

class GearDropAnimation extends StatefulWidget {
  final Gear gear;

  const GearDropAnimation({Key? key, required this.gear}) : super(key: key);

  @override
  State<GearDropAnimation> createState() => _GearDropAnimationState();
}

class _GearDropAnimationState extends State<GearDropAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnim;
  late final AnimationController _glowController;
  late final Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnim = Tween<double>(begin: -200, end: 0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.bounceOut),
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _glowAnim = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _bounceController.forward().whenComplete(() {
      _glowController.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Color _rarityColor(GearRarity r) {
    switch (r) {
      case GearRarity.common:
        return Colors.grey;
      case GearRarity.uncommon:
        return Colors.green;
      case GearRarity.rare:
        return Colors.blue;
      case GearRarity.epic:
        return Colors.purple;
      case GearRarity.legendary:
        return Colors.amber;
      case GearRarity.mythic:
        return Colors.red;
      case GearRarity.fabled:
        return Colors.cyan;
      case GearRarity.artifact:
        return Colors.deepOrange;
      case GearRarity.godly:
        return Colors.yellow;
      case GearRarity.transcendant:
        return Colors.indigo;
      case GearRarity.voidTier:
        return Colors.black87;
      case GearRarity.nullTier:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_bounceAnim, _glowAnim]),
      builder: (context, child) {
        final baseColor = _rarityColor(widget.gear.rarity);
        return Transform.translate(
          offset: Offset(0, _bounceAnim.value),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: baseColor.withOpacity(0.6),
                  blurRadius: _glowAnim.value,
                  spreadRadius: _glowAnim.value / 2,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: GearCard(gear: widget.gear),
    );
  }
}
