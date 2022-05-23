
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:kebabs/config/buttons.dart';
import 'package:kebabs/config/symbols.dart';
import 'package:kebabs/data/action_item.dart';
import 'package:kebabs/data/calculator_button_structure.dart';
import 'package:kebabs/data/number_item.dart';
import 'package:kebabs/model/calculator_model.dart';
import 'package:kebabs/model/converter_model.dart';
import 'package:kebabs/model/exchange_model.dart';
import 'package:kebabs/widgets/blinking_button.dart';
import 'package:kebabs/widgets/calculator_button.dart';
import 'package:kebabs/widgets/is_convert_dialog.dart';
import 'package:kebabs/widgets/keyboard.dart';
import 'package:kebabs/widgets/select_currency_dialog.dart';
import 'package:kebabs/widgets/side_bar_menu.dart';
import 'package:language_picker/languages.g.dart';
import 'package:provider/provider.dart';
import 'package:kebabs/constants/symbols.dart' as SymbolConstnats;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isConverterAll = true;
  static const List<String> _showDialogOfConvertSymbols = [
    SymbolConstnats.MULTIPICATION,
    SymbolConstnats.MINUS,
    SymbolConstnats.PLUS,
    SymbolConstnats.DIVISION,
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConverterModel convertModel = context.read<ConverterModel>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<ConverterModel>(
                builder: (context, converterModel, child) {
                  String fromCurrency = converterModel.fromCurrencyCode;
                  String toCurrency = converterModel.toCurrencyCode;
                  double rate = converterModel.rate;
                  String updatedAt = converterModel.updatedAt;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          fromCurrency.isEmpty || toCurrency.isEmpty ? BlinkingButton(
                            color: Colors.black38,
                            onPressed: _showSelectCurrencyDialog,
                            child: const Text(
                              'Choice currencies',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ) :
                          GestureDetector(
                              child: Text("$fromCurrency to $toCurrency"),
                            onTap: _showSelectCurrencyDialog,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          fromCurrency.isEmpty || toCurrency.isEmpty  ?
                              Container()
                              : Text(
                                "Rate $rate last updated at $updatedAt",
                                style: const TextStyle(
                                  fontSize: 12.0,
                                ),
                              ),
                        ],
                      )
                    ],
                  );
                }
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.arrow_2_circlepath,
              color: Colors.white,
            ),
            onPressed: () async {
              ConverterModel converterModel = context.read<ConverterModel>();
              if (
                converterModel.fromCurrencyCode.isEmpty || converterModel.toCurrencyCode.isEmpty
              ) {
                return;
              }

              Loader.show(context);
              await converterModel.refreshRate();
              Loader.hide();
            },
          ),
        ],
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.menu,
        //     color: Colors.white,
        //   ),
        //   onPressed: () {},
        // ),
      ),
      drawer: SideBarMenu(
        languageCode: 'en',
        supportedLanguages: [
          Languages.english,
          Languages.ukrainian,
          Languages.russian,
        ],
        chooseLanguage: () {

        },
        alwaysConvert: _isConverterAll,
        onChangeAlwaysConvert: (bool value) {
        },
      ),
      body: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Consumer<ConverterModel>(
                        builder: (context, converterModel, child) {
                          return _getFlagIcon(converterModel.getFromCurrency());
                        }
                      )
                    ),
                    Expanded(
                      flex: 8,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Consumer<ConverterModel>(
                            builder: (context, calculatorModel, child) {
                              return Text(
                                calculatorModel.inputText,
                                style: const TextStyle(
                                  fontSize: 40,

                                ),
                              );
                            }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                        flex: 2,
                        child: Consumer<ConverterModel>(
                            builder: (context, converterModel, child) {
                              return _getFlagIcon(converterModel.getToCurrency());
                            }
                        )
                    ),
                    Expanded(
                      flex: 8,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Consumer<ConverterModel>(
                            builder: (context, converterModel, child) {
                              return Text(
                                converterModel.outputText,
                                style: const TextStyle(
                                  fontSize: 40,
                                ),
                              );
                            }
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 20,
                child: Keyboard(
                  configButtons: configButtons,
                  onPressed: (BuildContext context, CalculatorButtonStructure button) {
                    print(button.isActionButton);
                    if (button.isActionButton) {
                      _onPressedActionButton(button);
                    } else {
                      _onPressedNumberButton(button);
                    }
                    context
                        .read<CalculatorModel>()
                        .pressedSymbol = button.symbol;

                  },
                ),
              ),
            ]
        ),
      ),
    );
  }

  void _onPressedActionButton(CalculatorButtonStructure button) async {
    ConverterModel converterModel = context.read<ConverterModel>();

    if (button.isActionButton) {
      converterModel.lastActionItem = ActionItem(symbol: button.symbol);
    }

    if (!_isConverterAll && _showDialogOfConvertSymbols.contains(button.symbol)) {
      _showIsConvertDialog(
        converterModel.getInputNumber(),
        (double number) {
          converterModel.addSymbolItem(
              NumberItem(isNeedConvert: true, number: number)
          );
          ActionItem item = ActionItem(symbol: button.symbol);
          converterModel.addSymbolItem(item);
        },
        (double number) {
          converterModel.addSymbolItem(
              NumberItem(isNeedConvert: false, number: number)
          );
          ActionItem item = ActionItem(symbol: button.symbol);
          converterModel.addSymbolItem(item);
        }
      );
    } else if (!_isConverterAll && button.symbol == SymbolConstnats.EQUAL) {
      _showIsConvertDialog(
        converterModel.getInputNumber(),
        (double number) {
          converterModel.addSymbolItem(
            NumberItem(isNeedConvert: true, number: number),
          );
          converterModel.calculateTotal();
        },
        (double number) {
          converterModel.addSymbolItem(
              NumberItem(isNeedConvert: false, number: number)
          );
          converterModel.calculateTotal();
        }
      );
    } else if (button.symbol == SymbolConstnats.BACKSPACE) {
      converterModel.removeLastSymbolFromInput();
    } else if (button.symbol == SymbolConstnats.CLEAR_CURRENT) {
      converterModel.setInputToDefault();
    } else if (button.symbol == SymbolConstnats.EQUAL) {
      converterModel.addSymbolItem(
        NumberItem(isNeedConvert: true, number: converterModel.getInputNumber()),
      );
      converterModel.calculateTotal();
    } else if (_showDialogOfConvertSymbols.contains(button.symbol)) {
      converterModel.addSymbolItem(
        NumberItem(isNeedConvert: true, number: converterModel.getInputNumber()),
      );
      converterModel.addSymbolItem(ActionItem(symbol: button.symbol));
    } else if (button.symbol == SymbolConstnats.CLEAR_ALL) {
      converterModel.clearAll();
    }
  }

  void _onPressedNumberButton(CalculatorButtonStructure button) {
    ConverterModel converterModel = context.read<ConverterModel>();
    converterModel.addSymbolTuCurrentNumber(button.symbol);
  }

  void _showIsConvertDialog(
    double number,
    Function onPressedYes,
    Function onPressedNo,
  ) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return IsConvertDialog(
          number: number,
          onPressYes: onPressedYes,
          onPressNo: onPressedNo,
        );
      }
    );
  }

  Widget _getFlagIcon(Currency? currency) {
    return null != currency ?
    GestureDetector(
      onTap: () {
        _showSelectCurrencyDialog();
      },
      child: Row(
        children: [
          const SizedBox(width: 10),
          Text(
            CurrencyUtils.currencyToEmoji(currency),
            style: const TextStyle(
              fontSize: 40,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    ) : Container();
  }

  void _showSelectCurrencyDialog() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const SelectCurrencyDialog();
      });
  }
}
