import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/helpers/error_alert.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/views/notes/supply_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final NotesService _notesService;
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    print("opening the DB");
    NotesService().open();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    NotesService().close();
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
                  await AuthService.firebase()
                      .login(email: email, password: password);
                  final user = AuthService.firebase().currentUser;

                  // Save firestore data to database
                  final streams = await FirebaseFirestore.instance
                      .collection('items')
                      .get();

                  final records = streams.docs
                      .map((e) =>
                          ItemRecord.fromMap(e.data(), reference: e.reference))
                      .toList();

                  records.forEach(
                    (element) =>
                        NotesService().createClinicItem(record: element),
                  );

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    notesRoute,
                    (route) => false,
                  );
                } on UserNotFoundAuthException {
                  showErrorDialog(context, 'User not found');
                } on WrongPasswordAuthException {
                  showErrorDialog(context, 'Wrong Password');
                } on GenericAuthException catch (_) {
                  showErrorDialog(context, 'Error: Authentication Error');
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
