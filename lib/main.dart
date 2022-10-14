import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        appBar: AppBar(
          title: const Text("Register"),
        ),
        body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
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
                          print("I was pressed");
                          final email = _email.text;
                          final password = _password.text;

                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                          print(userCredential);
                        },
                        child: const Text("Register"),
                      ),
                    ),
                  ],
                );

              default:
                return const Text("Loading...");
            }
          },
        ));
  }
}
