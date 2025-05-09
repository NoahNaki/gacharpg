// lib/widgets/damage_indicator.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/combat_provider.dart';

/// Shows a floating red “-X” text when the mob takes damage,
/// moving upward and fading out.
class DamageIndicator extends StatefulWidget {
  const DamageIndicator({Key? key}) : super(key: key);

  @override
  _DamageIndicatorState createState() => _DamageIndicatorState();
}

class _DamageIndicatorState extends State<DamageIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<double> _rise;
  int? _lastDamage;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _rise = Tween<double>(begin: 0.0, end: -40.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _lastDamage = null);
        _controller.reset();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen for combat updates
    Provider.of<CombatProvider>(context).addListener(_onCombatUpdate);
  }

  void _onCombatUpdate() {
    final dmg = Provider.of<CombatProvider>(context, listen: false).lastDamage;
    if (dmg != null && dmg != _lastDamage) {
      setState(() => _lastDamage = dmg);
      _controller.forward();
    }
  }

  @override
  void dispose() {
    Provider.of<CombatProvider>(context, listen: false)
        .removeListener(_onCombatUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_lastDamage == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, _rise.value),
            child: Text(
              '-$_lastDamage',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(blurRadius: 4, color: Colors.black45, offset: Offset(1, 1))
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
