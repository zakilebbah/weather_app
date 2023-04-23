import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utilFunctions.dart';

class SignUpPage extends ConsumerWidget {
  SignUpPage({super.key});
  TextEditingController _user = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _confirmPass = TextEditingController();

  // Function to create a new user, and check if the new user does not already exist in the local storage
  void signeUp(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_user.text != '' && _pass.text != '') {
      if (prefs.containsKey("user")) {
        String? userString = prefs.getString('user');
        Map<String, dynamic> user00 = jsonDecode(userString!);
        if (user00['USER'] == _user.text) {
          MyFunct.showErrorMessage("User exists", context);
        } else {
          await prefs.setString(
              'user',
              jsonEncode({
                'USER': _user.text,
                'EMAIL': _email.text,
                "PASS": _pass.text
              }));
          SnackBar snackBar = SnackBar(
            content: Text('Welcome ${_user.text}'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          context.pushNamed("countries-list");
        }
      } else {
        await prefs.setString(
            'user',
            jsonEncode({
              'USER': _user.text,
              'EMAIL': _email.text,
              "PASS": _pass.text
            }));
        SnackBar snackBar = SnackBar(
          content: Text('Welcome ${_user.text}'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        context.pushNamed("countries-list");
      }
    }
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
                  Colors.white,
                  Colors.blue,
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
                      margin: const EdgeInsets.all(10.0),
                      child: TextField(
                          controller: _user,
                          decoration: const InputDecoration(
                            labelText: 'User',
                          ))),
                  Container(
                      width: 260,
                      margin: const EdgeInsets.all(10.0),
                      child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ))),
                  Container(
                      width: 260,
                      margin: const EdgeInsets.all(10.0),
                      child: TextField(
                          controller: _pass,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ))),
                  Container(
                      width: 260,
                      margin: const EdgeInsets.all(10.0),
                      child: TextField(
                          controller: _confirmPass,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                          ))),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    width: 220,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 6,
                          shadowColor: Colors.grey.shade100),
                      onPressed: () {
                        signeUp(context);
                      },
                      child: Text(
                        'Create account',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
