import 'package:flutter/foundation.dart';

class ExchangeModel extends ChangeNotifier {
  String _fromCurrency = '';
  String _toCurrency = '';
  double _rate = 0.0;

  String get fromCurrency => _fromCurrency;
  String get toCurrency => _toCurrency;
  double get rate => _rate;

  void setExchangeModel(
    String fromCurrency,
    String toCurrency,
    double rate
  ) {
    _fromCurrency = fromCurrency;
    _toCurrency = toCurrency;
    _rate = rate;
    notifyListeners();
  }

  set fromCurrency(String value) {
    _fromCurrency = value;
    notifyListeners();
  }

  set toCurrency(String value) {
    _toCurrency = value;
    notifyListeners();
  }

  set rate(double value) {
    _rate = value;
    notifyListeners();
  }
}