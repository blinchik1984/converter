import 'package:flutter/material.dart';
import 'package:kebabs/config/symbols.dart';
import 'package:kebabs/data/calculator_button_structure.dart';
import 'package:kebabs/model/calculator_model.dart';
import 'package:provider/provider.dart';

class CalculatorButton extends StatefulWidget {
  final Function onPressed;
  final CalculatorButtonStructure buttonStructure;
  const CalculatorButton({
    Key? key,
    required this.onPressed,
    required this.buttonStructure
  }) : super(key: key);

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton> {
  late Color backgroundColor;
  late Color symbolColor;
  late String symbol;

  @override
  void initState() {
    super.initState();
    symbol = widget.buttonStructure.symbol;
    symbolColor = widget.buttonStructure.symbolColor;
    backgroundColor = widget.buttonStructure.backgroundColor;
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorModel>(
      builder: (context, calculatorModel, child) {
        return RawMaterialButton(
          elevation: 0.0,
          child: Text(
            symbol,
            style: TextStyle(
              color: _getSymbolColor(),
              fontSize: 30.0,
            ),
          ),
          onPressed: () {
            widget.onPressed(context, widget.buttonStructure);
            setState(() {
            });
          },
          constraints: BoxConstraints.tightFor(
            width: MediaQuery.of(context).size.width * 0.22,
            height: MediaQuery.of(context).size.width * 0.22,
          ),
          shape: CircleBorder(),
          fillColor: _getBackgroundColor(),
        );
      }
    );
  }

  Color _getBackgroundColor() {
    if (!widget.buttonStructure.isActionButton) {
      return widget.buttonStructure.backgroundColor;
    }
    return Provider.of<CalculatorModel>(context).pressedSymbol == symbol ?
      widget.buttonStructure.onPressedBackgroundColor : widget.buttonStructure.backgroundColor;
  }

  Color _getSymbolColor() {
    if (!widget.buttonStructure.isActionButton) {
      return widget.buttonStructure.symbolColor;
    }
    return Provider.of<CalculatorModel>(context).pressedSymbol == symbol ?
      widget.buttonStructure.onPressedSymbolColor : widget.buttonStructure.symbolColor;
  }
}
