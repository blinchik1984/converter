import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kebabs/config/supported_locales.dart';
import 'package:kebabs/widgets/screen/home.dart';
import 'package:kebabs/widgets/select_currency_dialog.dart';

class App extends StatelessWidget {
  static const String _title = 'Converter';
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: supportedLocales,
      home: Home(),
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: CupertinoColors.systemOrange,
      ),
    );
  }
}

  void showSelectCurrenciesDialog(BuildContext context) {
    showDialog(context: context, builder: (BuildContext context) {
      return SelectCurrencyDialog();
    });
  // return showDialog<void>(
  //   context: context,
  //   barrierDismissible: false, // user must tap button!
  //   builder: (BuildContext context) {
  //     return AlertDialog(
  //       title: const Text('AlertDialog Title'),
  //       content: SingleChildScrollView(
  //         child: ListBody(
  //           children: const <Widget>[
  //             Text('This is a demo alert dialog.'),
  //             Text('Would you like to approve of this message?'),
  //           ],
  //         ),
  //       ),
  //       actions: <Widget>[
  //         TextButton(
  //           child: const Text('Approve'),
  //           onPressed: () {
  //             Navigator.of(context).pop();
  //           },
  //         ),
  //       ],
  //     );
  //   },
  // );
}