import 'package:doc_trial/models/screen_argument_model.dart';
import 'package:doc_trial/screens/chat_screen.dart';
import 'package:doc_trial/screens/home_screen.dart';
import 'package:doc_trial/screens/login_screen.dart';
import 'package:doc_trial/screens/registration_screen.dart';
import 'package:doc_trial/utils/routes.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    //print('settings.name ${settings.name}');
    final args = settings.arguments;
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.registrationScreen:
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case Routes.chatScreen:
        return MaterialPageRoute(builder: (_) => ChatScreen(screenArguments: args as ScreenArguments,));
      default:
        return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: SafeArea(child: Text('Route Error'))));
    }
  }
}
