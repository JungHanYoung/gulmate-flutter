import 'package:flutter/material.dart';
import 'package:gulmate/model/family.dart';

class FamilyService with ChangeNotifier {

  Family _currentFamily;

  Family get getFamily => _currentFamily;

  void setFamily(Family family) {
    _currentFamily = family;
  }

}