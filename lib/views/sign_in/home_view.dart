import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/sign_in/register_view.dart';
import 'package:mynotes/views/sign_in/verify_email_view.dart';
import '../../firebase_options.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  log('Email is verified');
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const RegisterView();
              }
            // if (user?.emailVerified ?? false) {
            //   return const Text("Done");
            // } else {
            //   return RegisterView();
            // }
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}
