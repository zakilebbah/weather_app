import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utilFunctions.dart';

class ConnectionPage extends ConsumerWidget {
  ConnectionPage({super.key});
  TextEditingController _user = TextEditingController();
  TextEditingController _pass = TextEditingController();

  // Function to check if user and pass are the same as on the local storage
  void logIn(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("user")) {
      String? userString = prefs.getString('user');
      Map<String, dynamic> user00 = jsonDecode(userString!);
      if (user00['USER'] == _user.text && user00['PASS'] == _pass.text) {
        SnackBar snackBar = SnackBar(
          content: Text('Welcome ${_user.text}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.goNamed("countries-list");
      } else {
        MyFunct.showErrorMessage(
            "Invalid username or password. Please try again", context);
      }
    }
  }

  // Function to reset password by providing the old the user name, then replace old pass with the new one
  Future<void> resetPassword(
      BuildContext context, String user0, String pass0) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("user")) {
      String? userString = prefs.getString('user');
      Map<String, dynamic> user00 = jsonDecode(userString!);
      if (user00['USER'] == user0) {
        user00['PASS'] = pass0;
        await prefs.setString('user', jsonEncode(user00));
        SnackBar snackBar = const SnackBar(
          content: Text('Your password has been reset'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        MyFunct.showErrorMessage("Invalid username. Please try again", context);
      }
    } else {
      MyFunct.showErrorMessage(
          "Invalid username or password. Please try again", context);
    }
  }

  // function to show the reset password dialog
  Future<void> _showMyResetDialog(BuildContext context) async {
    TextEditingController user00 = TextEditingController();
    TextEditingController newPass = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password reset'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                    width: 260,
                    margin: const EdgeInsets.all(20.0),
                    child: TextField(
                        controller: user00,
                        decoration: const InputDecoration(
                          labelText: 'User',
                        ))),
                Container(
                    width: 260,
                    margin: const EdgeInsets.all(20.0),
                    child: TextField(
                        controller: newPass,
                        decoration: const InputDecoration(
                          labelText: 'New password',
                        ))),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reset Password'),
              onPressed: () async {
                await resetPassword(context, user00.text, newPass.text);
                FocusManager.instance.primaryFocus?.unfocus();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Center(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.white,
                ],
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle_rounded,
                    color: Colors.white,
                    size: 82,
                  ),
                  Container(
                      width: 260,
                      margin: const EdgeInsets.all(20.0),
                      child: TextField(
                          controller: _user,
                          decoration: const InputDecoration(
                            labelText: 'User',
                          ))),
                  Container(
                      width: 260,
                      margin: const EdgeInsets.all(20.0),
                      child: TextField(
                          controller: _pass,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ))),
                  GestureDetector(
                    onTap: () => _showMyResetDialog(context),
                    child: Text(
                      "Forgot your password ?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, bottom: 16),
                    width: 220,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.grey.shade100),
                      onPressed: () {
                        logIn(context);
                      },
                      child: Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w400),
                      ),
                      GestureDetector(
                        onTap: () => context.goNamed("signe-up"),
                        child: const Text(
                          "Create",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
