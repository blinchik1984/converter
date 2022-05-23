import 'dart:convert';
import 'dart:io';

import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:kebabs/GetRateResponse.dart';
import 'package:kebabs/data/action_item.dart';
import 'package:kebabs/data/number_item.dart';
import 'package:kebabs/data/symbol_item.dart';
import 'package:kebabs/model/converted_number.dart';
import 'package:kebabs/constants/symbols.dart' as SymbolConstnats;

class ConverterModel extends ChangeNotifier {
  final CurrencyService _currencyService = CurrencyService();
  static const _DEFAULT_TEXT = '0';
  static const _max_length_output_text = 9999999999999;
  String _outputText = ConverterModel._DEFAULT_TEXT;
  String _inputText = ConverterModel._DEFAULT_TEXT;
  double _total = 0.0;
  double _rate = 1.0;
  double _currentNumber = 0;
  int _currentIndex = 0;
  String _fromCurrency = '';
  String _toCurrency = '';
  String _updatedAt = '';
  double _convertedTotal = 0.0;
  double _notConvertedTotal = 0.0;
  Map<int, SymbolItem> _symbolItems = {};
  ActionItem? _lastAction;

  String get outputText => _outputText;
  String get inputText => _inputText;
  double get total => _total;
  double get rate => _rate;
  String get fromCurrencyCode => _fromCurrency;
  String get toCurrencyCode => _toCurrency;
  String get updatedAt => _updatedAt;

  void refresh() {
    notifyListeners();
  }

  Currency? getFromCurrency() {
    return _findCurrencyByCode(_fromCurrency);
  }

  Currency? getToCurrency() {
    return _findCurrencyByCode(_toCurrency);
  }

  Future refreshRate() async {
    if (_fromCurrency.isEmpty || _toCurrency.isEmpty) {
      return;
    }

    await initCurrenciesAndRate(_fromCurrency, _toCurrency);
    refresh();
  }

  bool _isEmptyInputText() {
    return _inputText == ConverterModel._DEFAULT_TEXT;
  }

  double getInputNumber() {
    var number = double.parse(_inputText);
    assert(number is double);

    return number;
  }

  void addSymbolTuCurrentNumber(String number) {
    if (_isEmptyInputText() && number == _DEFAULT_TEXT) {
      return;
    }

    if (!_canBeChangeInput()) {
      return;
    }

    _inputText = _isEmptyInputText() ? number : _inputText + number;
    _refreshOutputText();
    notifyListeners();
  }

  void setInputToDefault() {
    _inputText = _DEFAULT_TEXT;
    _outputText = _DEFAULT_TEXT;
    _currentNumber = 0;
    notifyListeners();
  }

  void clearAll() {
    _inputText = _DEFAULT_TEXT;
    _outputText = _DEFAULT_TEXT;
    _currentNumber = 0;
    _currentIndex = 0;
    _symbolItems = {};
    _convertedTotal = 0.0;
    _notConvertedTotal = 0.0;
    notifyListeners();
  }

  void removeLastSymbolFromInput() {
    if (_isEmptyInputText() || !_canBeChangeInput()) {
      return;
    }

    if (
      _symbolItems.isNotEmpty
    ) {
      SymbolItem? symbolItem = _symbolItems[_symbolItems.length - 1];
      if (symbolItem is ActionItem && symbolItem.symbol == SymbolConstnats.EQUAL) {
        return;
      }
    }

    if (_inputText.length == 1) {
      _inputText = _DEFAULT_TEXT;
      _outputText = _DEFAULT_TEXT;
      notifyListeners();

      return;
    }

    _inputText = _inputText.substring(0, _inputText.length - 1);
    _refreshOutputText();
    notifyListeners();
  }

  set lastActionItem(ActionItem actionItem) {
    _lastAction = actionItem;
  }

  void _refreshOutputText() {
    double? doubleNumber = double.tryParse(_inputText);
    if (doubleNumber is! double) {
      return;
    }
    _currentNumber = doubleNumber;
    double convertedNumber = _currentNumber * _rate;

    _outputText = convertedNumber != 0.0 ? convertedNumber.toStringAsFixed(2) : _DEFAULT_TEXT;

    if (convertedNumber > _max_length_output_text) {
      _outputText = convertedNumber.toStringAsExponential(10);
    }
  }

  void calculateTotal() {
    ActionItem? previousAction;
    _convertedTotal = 0;
    _notConvertedTotal = 0;
    print("_notConvertedTotal: $_notConvertedTotal");
    _symbolItems.forEach((int index, SymbolItem item) {
      print("index: $index");
      if (item is NumberItem) {
        print("number: ${item.number}");
        double convertedNumber = item.isNeedConvert ? item.number * _rate : item.number;
        double notConvertedNumber = item.number;
        if (index == 0) {
          _convertedTotal += convertedNumber;
          _notConvertedTotal += notConvertedNumber;
        } else if (previousAction != null) {
          switch(previousAction?.symbol) {
            case SymbolConstnats.DIVISION:
              _convertedTotal /= convertedNumber;
              _notConvertedTotal /= notConvertedNumber;
              break;
            case SymbolConstnats.PLUS:
              _convertedTotal += convertedNumber;
              _notConvertedTotal += notConvertedNumber;
              break;
            case SymbolConstnats.MINUS:
              _convertedTotal -= convertedNumber;
              _notConvertedTotal -= notConvertedNumber;
              break;
            case SymbolConstnats.MULTIPICATION:
              _convertedTotal *= convertedNumber;
              _notConvertedTotal *= notConvertedNumber;
              break;
          }
        }
      }
      if (item is ActionItem) {
        print("action: ${item.symbol}");
        previousAction = item;
      }
      print("_notConvertedTotal after calculate $_notConvertedTotal");
    });

    _inputText = _notConvertedTotal.toStringAsFixed(2);
    _outputText = _convertedTotal.toStringAsFixed(2);

    if (_convertedTotal > _max_length_output_text) {
      _outputText = _convertedTotal.toStringAsExponential(10);
    }
    if (_notConvertedTotal > _max_length_output_text) {
      _inputText = _notConvertedTotal.toStringAsExponential(10);
    }
    _currentIndex = 0;
    _currentNumber = 0;
    _notConvertedTotal = 0;
    _convertedTotal = 0;
    _symbolItems = {};

    notifyListeners();
  }

  Future<InitRateResponse> initCurrenciesAndRate(
      String fromCurrency,
      String toCurrency
  ) async {
    String from = fromCurrency.toLowerCase();
    String to = toCurrency.toLowerCase();
    String url = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/$from/$to.json";
    HttpClient httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonString = await response.transform(utf8.decoder).join();
        Map data = json.decode(jsonString);
        if (data.containsKey(to)) {
          assert(data[to] is double);
          _fromCurrency = fromCurrency;
          _toCurrency = toCurrency;
          _updatedAt = data['date'] ?? '';
          _rate = data[to];
          _refreshOutputText();

          return InitRateResponse(
            rate: _rate,
            errorMessage: null,
            updatedAt: data['date'] ?? '',
          );
        } else {
          return InitRateResponse(
            rate: 0.0,
            errorMessage: "Something went wrong",
            updatedAt: '',
          );
        }
      } else {
        return InitRateResponse(
          rate: 0.0,
          errorMessage: "Please check connection to internet",
          updatedAt: '',
        );
      }
    } catch (exception) {
      print(exception);
      return InitRateResponse(
        rate: 0.0,
        errorMessage: "Something went wrong",
        updatedAt: '',
      );
    }
  }

  void addSymbolItem(SymbolItem symbolItem) {
    if (symbolItem is ActionItem) {
      print("add action ${symbolItem.symbol}");
    }
    if (symbolItem is NumberItem) {
      print("add action ${symbolItem.number}");
    }
    _symbolItems[_currentIndex] = symbolItem;
    _currentIndex++;
    setInputToDefault();

  }

  set inputText(String value) {
    _inputText = value;
    notifyListeners();
  }

  Currency? _findCurrencyByCode(String code) {
    return _currencyService.findByCode(code);
  }

  bool _canBeChangeInput() {
    if (null == _lastAction) {
      return true;
    }

    return _lastAction?.symbol != SymbolConstnats.EQUAL;
  }
}