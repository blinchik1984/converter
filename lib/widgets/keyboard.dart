import 'package:flutter/cupertino.dart';
import 'package:kebabs/data/calculator_button_structure.dart';
import 'package:kebabs/widgets/buttons_row.dart';

class Keyboard extends StatelessWidget {
  final Function onPressed;
  final List<List<CalculatorButtonStructure>> configButtons;

  const Keyboard({
    Key? key,
    required this.onPressed,
    required this.configButtons
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _buildRowsList(),
    );
  }

  List<ButtonsRow> _buildRowsList() {
    List<ButtonsRow> rowList = [];
    for (List<CalculatorButtonStructure>configRow in configButtons) {
      rowList.add(
        ButtonsRow(configRow: configRow, onPressed: onPressed),
      );
    }

    return rowList;
  }
}
