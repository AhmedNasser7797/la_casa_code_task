import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class HelpFunctions {
  static Future<void> showToast(String text, BuildContext context) async {
    await Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey.withOpacity(0.4),
      textColor: Theme.of(context).textTheme.headline1!.color,
      fontSize: 16.0,
    );
  }
}
