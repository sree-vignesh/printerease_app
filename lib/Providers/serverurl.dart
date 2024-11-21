import 'package:flutter/material.dart';

class ServerProvider extends ChangeNotifier {
  String? _serverUrl = 'http://10.0.2.2:3000';

  String? get serverUrl => _serverUrl;

  void setServerUrl(String? url) {
    _serverUrl = url;
    notifyListeners();
  }
}
