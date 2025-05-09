// lib/widgets/screen_shake.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/combat_provider.dart';

/// Wraps its [child] in a small padded ClipRect so only the inner region shakes,
/// preventing you from seeing the edges move.
class ScreenShake extends StatefulWidget {
  final Widget child;
  const ScreenShake({Key? key, required this.child}) : super(key: key);

  @override
  _ScreenShakeState createState() => _ScreenShakeState();
}

class _ScreenShakeState extends State<ScreenShake>
    with SingleTickerProviderStateMixin {
  static const double _maxOffset = 8.0;   // same as your shake intensity
  late final AnimationController _controller;
  late final Random _rnd;
  int? _lastSeenDamage;

  @override
  void initState() {
    super.initState();
    _rnd = Random();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        // clear the guard so that the next hit—even if it's the same damage—
        // will retrigger the shake
        _lastSeenDamage = null;
      }
    });

    // Delay listener registration until after the first frame so context.read()
    // finds the provider.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CombatProvider>().addListener(_onCombatUpdate);
    });
  }

  void _onCombatUpdate() {
    final dmg = context.read<CombatProvider>().lastDamage;
    if (dmg != null && dmg != _lastSeenDamage) {
      _lastSeenDamage = dmg;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    context.read<CombatProvider>().removeListener(_onCombatUpdate);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pad inward by _maxOffset on all sides so the shaking content never reveals edges.
    return Padding(
      padding: const EdgeInsets.all(_maxOffset),
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          child: widget.child,
          builder: (context, child) {
            // Shake eases out over the duration:
            final progress = 1.0 - _controller.value;
            final dx = (_rnd.nextDouble() * 2 - 1) * _maxOffset * progress;
            final dy = (_rnd.nextDouble() * 2 - 1) * _maxOffset * progress;
            return Transform.translate(
              offset: Offset(dx, dy),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
