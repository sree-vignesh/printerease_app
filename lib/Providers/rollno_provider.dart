import 'package:flutter/foundation.dart';

class RollNoProvider extends ChangeNotifier {
  String? _rollNo;

  String? get rollNo => _rollNo;

  void setRollNo(String? rollNo) {
    _rollNo = rollNo;
    notifyListeners(); // Notify listeners about the change
  }
}
