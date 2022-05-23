import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:kebabs/GetRateResponse.dart';
import 'package:kebabs/config/currencies.dart';

class Helper {
  static List<DropdownMenuItem<String>> dropdownMenuItems = [];
  static Future<InitRateResponse> getRate(
      String fromCurrency,
      String toCurrency,
      BuildContext context,
  ) async {
    Loader.show(context);
    String from = fromCurrency.toLowerCase();
    String to = toCurrency.toLowerCase();
    String url = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/$from/$to.json";
    HttpClient httpClient = HttpClient();
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var jsonString = await response.transform(utf8.decoder).join();
        Map data = json.decode(jsonString);
        print(data);
        if (data.containsKey(to)) {
          Loader.hide();
          return InitRateResponse(
              rate: data[to],
              errorMessage: null,
              updatedAt: data['date'] ?? '',
          );
        } else {
          Loader.hide();
          return InitRateResponse(
            rate: 0.0,
            errorMessage: "Something went wrong",
            updatedAt: '',
          );
        }
      } else {
        Loader.hide();
        return InitRateResponse(
          rate: 0.0,
          errorMessage: "Please check connection to internet",
          updatedAt: '',
        );
      }
    } catch (exception) {
      Loader.hide();
      return InitRateResponse(
        rate: 0.0,
        errorMessage: exception.toString(),
        updatedAt: '',
      );
    }
  }

  static List<DropdownMenuItem<String>> getCurrenciesMenu() {
    if (Helper.dropdownMenuItems.isNotEmpty) {
      return Helper.dropdownMenuItems;
    }

    currencies.forEach((String short, String long) => {
      Helper.dropdownMenuItems.add(
        DropdownMenuItem<String>(
          child: Text(long),
          value: short,
        ),
      )
    });

    return Helper.dropdownMenuItems;
  }
}