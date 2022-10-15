import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: const Text('Please verify your email'),
              ),
              TextButton(
                  onPressed: () async {
                    print('Sending email var');
                    final user = FirebaseAuth.instance.currentUser;
                    print(user?.email);
                    await user?.sendEmailVerification();
                  },
                  child: const Text('Send email verification'))
            ],
          ),
        ),
      ),
    );
  }
}
