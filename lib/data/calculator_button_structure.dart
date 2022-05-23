import 'package:flutter/material.dart';

class CalculatorButtonStructure {
  final String symbol;
  final Color backgroundColor;
  final Color symbolColor;
  final Color onPressedBackgroundColor;
  final Color onPressedSymbolColor;
  final bool isEmptyButton;
  final bool isActionButton;

  CalculatorButtonStructure({
    required this.symbol,
    required this.backgroundColor,
    required this.symbolColor,
    required this.onPressedBackgroundColor,
    required this.onPressedSymbolColor,
    required this.isEmptyButton,
    required this.isActionButton
  });
}