import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/error_alert.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'Please enter your email here'),
              controller: _email,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              enableSuggestions: false,
              obscureText: true,
              autocorrect: false,
              decoration: const InputDecoration(
                  hintText: 'Please enter your password here'),
              controller: _password,
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;
                try {
                  final credentials = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email, password: password);
                  log(credentials.toString());
                  if (credentials.user?.emailVerified ?? false) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      notesRoute,
                      (route) => false,
                    );
                  } else {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute,
                      (route) => false,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    showErrorDialog(context, 'User not found');
                  } else if (e.code == 'wrong-password') {
                    showErrorDialog(context, 'Wrong Password');
                  } else {
                    showErrorDialog(context, 'Error: ${e.code}');
                  }
                } catch (e) {
                  showErrorDialog(context, 'Error: ${e.toString()}');
                }
              },
              child: const Text("Login"),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text("Not Registered Yet? Register Here"))
        ],
      ),
    );
  }
}
