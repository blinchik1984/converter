import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const DialogButton({
    Key? key,
    required this.text,
    required this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          Colors.black38,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: () {
        onPressed();
      },
    );
  }
}
