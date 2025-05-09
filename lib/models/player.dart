import 'gear.dart';

class Player {
  Map<GearSlot, Gear?> equipment = {
    GearSlot.sword: null,
    GearSlot.helmet: null,
    GearSlot.chestplate: null,
    GearSlot.leggings: null,
    GearSlot.boots: null,
    GearSlot.amulet: null,
  };
  int hammers = 10;
  double luck = 0;
  int xp = 0;
  int level = 1;

  int get xpToNext => level * level * 100;
}