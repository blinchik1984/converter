import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:kebabs/GetRateResponse.dart';
import 'package:kebabs/helper.dart';
import 'package:kebabs/model/converter_model.dart';
import 'package:kebabs/model/exchange_model.dart';
import 'package:kebabs/widgets/dialog_button.dart';
import 'package:kebabs/widgets/select_currency_button.dart';
import 'package:provider/provider.dart';

class SelectCurrencyDialog extends StatefulWidget {
  const SelectCurrencyDialog({Key? key}) : super(key: key);

  @override
  _SelectCurrencyDialogState createState() => _SelectCurrencyDialogState();
}

class _SelectCurrencyDialogState extends State<SelectCurrencyDialog> {
  String _fromCurrencyCode = '';
  String _toCurrencyCode = '';
  String _error = '';

  @override
  Widget build(BuildContext context) {
    Widget errorMessage = _error.isNotEmpty ?
        Text(
          _error,
          style: const TextStyle(
            color: Colors.red,
          ),
        ) : Container();
    ConverterModel converterModel = context.watch<ConverterModel>();
    _fromCurrencyCode = converterModel.fromCurrencyCode;
    _toCurrencyCode = converterModel.toCurrencyCode;
    Currency? fromCurrency = converterModel.getFromCurrency();
    Currency? toCurrency = converterModel.getToCurrency();

    return AlertDialog(
      title: const Text('Please choice currencies'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            errorMessage,
            SelectCurrencyButton(
              currency: fromCurrency,
              onSelect: (Currency? currency) {
                _fromCurrencyCode = currency?.code ?? '';
              }
            ),
            SelectCurrencyButton(
                currency: toCurrency,
                onSelect: (Currency? currency) {
                  _toCurrencyCode = currency?.code ?? '';
                }
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              flex: 1,
              child: DialogButton(
                  text: 'ok',
                  onPressed: _setCurrencyRate,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: DialogButton(
                  text: 'cancel',
                  onPressed: () => {
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

  void _setCurrencyRate() async {
    ConverterModel converterModel = context.read<ConverterModel>();
    _error = '';
    if (_fromCurrencyCode.isEmpty) {
      setState(() {
        _error = "Please select FROM currency";
      });
    } else if (_toCurrencyCode.isEmpty) {
      setState(() {
        _error = "Please select TO currency";
      });
    } else if (_fromCurrencyCode == _toCurrencyCode) {
      setState(() {
        _error = "Please choice different currencies";
      });
    } else {
      Loader.show(context);
      InitRateResponse response = await converterModel.initCurrenciesAndRate(
        _fromCurrencyCode,
        _toCurrencyCode,
      );
      converterModel.refresh();
      if (null != response.errorMessage) {
        _error = response.errorMessage ?? '';
      }
    }
    if (_error.isEmpty) {
      Navigator.of(context).pop();
    }
    Loader.hide();
  }
}
