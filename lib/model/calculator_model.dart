import 'package:flutter/foundation.dart';

class CalculatorModel extends ChangeNotifier {
  String _pressedSymbol = '';

  String get pressedSymbol => _pressedSymbol;

  set pressedSymbol(String value) {
    _pressedSymbol = value;
    notifyListeners();
  }
}
