import 'package:flutter/material.dart';

class MyFunct {
  static List<double> fromListToDoubleList(List<dynamic> list00) {
    List<double> listToReturn = [];
    for (var item in list00) {
      listToReturn.add(double.parse(item.toString()));
    }
    return listToReturn;
  }

  static void showErrorMessage(String message0, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message0,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(seconds: 4),
      backgroundColor: Colors.red.shade800,
    ));
  }
}
