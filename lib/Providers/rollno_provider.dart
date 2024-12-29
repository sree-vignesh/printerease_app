import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RollNoProvider extends ChangeNotifier {
  String? _rollNo;

  String? get rollNo => _rollNo;

  // Constructor to load the saved Roll Number from SharedPreferences
  RollNoProvider() {
    _loadRollNo();
  }

  // Load Roll Number from SharedPreferences
  Future<void> _loadRollNo() async {
    final prefs = await SharedPreferences.getInstance();
    _rollNo = prefs.getString('rollNo'); // Retrieve the stored value
    notifyListeners(); // Notify listeners after initializing
  }

  // Save Roll Number to SharedPreferences and update the provider
  Future<void> setRollNo(String? rollNo) async {
    _rollNo = rollNo;

    final prefs = await SharedPreferences.getInstance();
    if (rollNo != null) {
      await prefs.setString(
          'rollNo', rollNo); // Save the value to SharedPreferences
    } else {
      await prefs.remove('rollNo'); // Remove the value if it's null
    }

    notifyListeners(); // Notify listeners about the change
  }
}
