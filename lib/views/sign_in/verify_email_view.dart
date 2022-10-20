import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_service.dart';

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
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'We\'ve already sent you a verification email. Please open it to verify your account.'),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'If you haven\'t received a verification email yet, press the button below.'),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Text('Please verify your email'),
              ),
              TextButton(
                  onPressed: () async {
                    log('Sending email var');
                    await AuthService.firebase().sendEmailVerification();
                  },
                  child: const Text('Send email verification')),
              TextButton(
                  onPressed: () async {
                    await AuthService.firebase().logOut();
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
