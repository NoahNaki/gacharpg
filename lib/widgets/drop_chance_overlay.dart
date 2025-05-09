import 'package:flutter/material.dart';
import '../models/gear.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class DropChanceOverlay extends StatelessWidget {
  const DropChanceOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chances = context.watch<GameProvider>().dropChances;

    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Drop Chances',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...GearRarity.values.map((r) {
                final pct = chances[r]!.toStringAsFixed(2);
                final label = r.toString().split('.').last;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '$label: $pct%',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}