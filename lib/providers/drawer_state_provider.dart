import 'package:flutter/foundation.dart';

enum DrawerElement {
  GetInspired,
  ManageContributions,
  Settings,
}

class DrawerStateInfo with ChangeNotifier {
  var _currentDrawer = DrawerElement.GetInspired;
  DrawerElement get getCurrentDrawer => _currentDrawer;

  void setCurrentDrawer(DrawerElement element) {
    _currentDrawer = element;
    notifyListeners();
  }
}
