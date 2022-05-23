import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kebabs/widgets/dialog_button.dart';

class IsConvertDialog extends StatelessWidget {
  final double number;
  final Function onPressYes;
  final Function onPressNo;
  const IsConvertDialog({
    Key? key,
    required this.number,
    required this.onPressYes,
    required this.onPressNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Align(
        alignment: Alignment.center,
        child: Text("Convert this number $number?"),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              flex: 1,
              child: DialogButton(
                text: 'YES',
                onPressed: () {
                  onPressYes(number);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: DialogButton(
                    text: 'NO',
                    onPressed: () => {
                      onPressNo(number),
                      Navigator.of(context).pop()
                    }
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
