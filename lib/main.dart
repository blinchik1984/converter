import 'package:flutter/material.dart';
import 'package:kebabs/model/calculator_model.dart';
import 'package:kebabs/model/converter_model.dart';
import 'package:kebabs/model/exchange_model.dart';
import 'package:kebabs/widgets/app.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ConverterModel()),
          ChangeNotifierProvider(create: (_) => CalculatorModel()),
        ],
        child: const App(),
      )
  );
}
