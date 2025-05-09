
import 'package:flutter/material.dart';
import '../models/gear.dart';

void showGearPopup(BuildContext context, Gear gear) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('${gear.name} [${gear.rarity.name.toUpperCase()}]'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Slot: ${gear.slot.name}'),
            Text('Level: ${gear.level}'),
            Text('Power: ${gear.power}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          )
        ],
      );
    },
  );
}
