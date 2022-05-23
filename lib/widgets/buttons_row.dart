import 'package:flutter/cupertino.dart';
import 'package:kebabs/data/calculator_button_structure.dart';
import 'package:kebabs/widgets/calculator_button.dart';

class ButtonsRow extends StatelessWidget {
  final List<CalculatorButtonStructure> configRow;
  final Function onPressed;

  const ButtonsRow({
    Key? key,
    required this.configRow,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _buildChildrenList(context),
    );
  }

  List<Widget> _buildChildrenList(BuildContext context) {
    List<Widget> rowChildren = [];
    for (var calculatorButtonStructure in configRow) {
      if (calculatorButtonStructure.isEmptyButton) {
        rowChildren.add(
          Flexible(
            flex: 1,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.22,
            ),
          )
        );

        continue;
      }

      rowChildren.add(
        Flexible(
          flex: 1,
          child: CalculatorButton(
            onPressed: onPressed,
            buttonStructure: calculatorButtonStructure,
          ),
        ),
      );
    }

    return rowChildren;
  }
}
