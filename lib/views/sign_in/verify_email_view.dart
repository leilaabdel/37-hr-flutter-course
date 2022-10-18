import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mynotes/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(
        appBar: AppBar(title: const Text('Verify Email')),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                    'We\'ve already sent you a verification email. Please open it to verify your account.'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                    'If you haven\'t received a verification email yet, press the button below.'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: const Text('Please verify your email'),
              ),
              TextButton(
                  onPressed: () async {
                    log('Sending email var');
                    final user = FirebaseAuth.instance.currentUser;
                    log(user?.email.toString() ?? '');
                    await user?.sendEmailVerification();
                  },
                  child: const Text('Send email verification')),
              TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  },
                  child: const Text('Restart'))
            ],
          ),
        ),
      ),
    );
  }
}
