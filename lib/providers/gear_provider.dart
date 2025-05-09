import 'package:flutter/material.dart';

class GearProvider with ChangeNotifier {
  int _totalPower = 0;
  int get totalPower => _totalPower;

  int _hammers = 0;
  int get hammers => _hammers;

  void equipGearPower(int power) {
    _totalPower = power;
    notifyListeners();
  }

  void addHammers(int count) {
    _hammers += count;
    notifyListeners();
  }
}
