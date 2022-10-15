import 'package:flutter/material.dart';
import 'package:mynotes/views/sign_in/home_view.dart';
import 'package:mynotes/views/sign_in/login_view.dart';
import 'package:mynotes/views/sign_in/register_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomeView(),
    routes: {
      '/login/': ((context) => const LoginView()),
      '/register/': (context) => const RegisterView()
    },
  ));
}
