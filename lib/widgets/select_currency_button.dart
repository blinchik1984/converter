import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectCurrencyButton extends StatefulWidget {
  final Currency? currency;
  final Function onSelect;

  const SelectCurrencyButton({
    Key? key,
    required this.currency,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<SelectCurrencyButton> createState() => _SelectCurrencyButtonState();
}

class _SelectCurrencyButtonState extends State<SelectCurrencyButton> {
  Currency? _currency;
  @override
  void initState() {
    super.initState();
    _currency = widget.currency;
  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black12)),
      onPressed: () {
        showCurrencyPicker(
          context: context,
          showFlag: true,
          showCurrencyName: true,
          showCurrencyCode: true,
          onSelect: (Currency? currency) {
            widget.onSelect(currency);
            setState(() {
              _currency = currency;
            });
          },
          favorite: ['SEK'],
        );
      },
      child: null == _currency ?
      Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Choose currency',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      )
      : Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 15),
                Text(
                  CurrencyUtils.currencyToEmoji(_currency),
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _currency?.code ?? '',
                        style: const TextStyle(fontSize: 17),
                      ),
                      Text(
                        _currency?.name ?? '',
                        style: TextStyle(fontSize: 15, color: Theme.of(context).hintColor),
                      ),
                    ]
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
