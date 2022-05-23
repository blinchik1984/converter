import 'package:kebabs/data/symbol_item.dart';

class NumberItem extends SymbolItem {
  final bool isNeedConvert;
  final double number;

  NumberItem({required this.isNeedConvert, required this.number});
}