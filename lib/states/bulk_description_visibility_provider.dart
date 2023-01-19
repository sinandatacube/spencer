import 'package:flutter/material.dart';

class BulkDescriptionProvider extends ChangeNotifier {
  bool visible = false;

  updateVisibility() {
    visible = !visible;
    notifyListeners();
  }
}
