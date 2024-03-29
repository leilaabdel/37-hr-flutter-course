import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/views/notes/item_view.dart';
import 'package:mynotes/views/notes/new_patient_view.dart';
import 'package:mynotes/views/notes/notes_view.dart';
import 'package:mynotes/views/notes/patient_view.dart';
import 'package:mynotes/views/notes/supply_view.dart';
import 'package:mynotes/views/sign_in/home_view.dart';
import 'package:mynotes/views/sign_in/login_view.dart';
import 'package:mynotes/views/sign_in/register_view.dart';
import 'package:mynotes/views/sign_in/verify_email_view.dart';
import 'package:path/path.dart';
import 'package:mynotes/helpers/router.dart' as router;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomeView(),
    routes: {
      loginRoute: ((context) => const LoginView()),
      registerRoute: (context) => const RegisterView(),
      notesRoute: (context) => const NotesView(),
      verifyEmailRoute: (context) => const VerifyEmailView(),
      suppliesLandingRoute: (context) => const SupplyView(),
      patientsLandingRoute: (context) => const PatientView(),
      newPatientFormRoute: (context) => const NewPatientFrom(),
    },
    onGenerateRoute: router.generateRoute,
  ));
}
