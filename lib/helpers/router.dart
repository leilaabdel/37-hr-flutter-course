import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/views/notes/item_view.dart';
import 'package:mynotes/views/sign_in/login_view.dart';
import 'package:mynotes/views/sign_in/register_view.dart';

import '../constants/routes.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case loginRoute:
      return MaterialPageRoute(builder: (context) => LoginView());
    case registerRoute:
      return MaterialPageRoute(builder: (context) => RegisterView());
    case specificSupplyItemRoute:
      var itemArgument = settings.arguments;
      return MaterialPageRoute(
          builder: (context) => ItemView(
                clinicItem: itemArgument as ClinicItem,
              ));
    default:
      return MaterialPageRoute(builder: (context) => LoginView());
  }
}
