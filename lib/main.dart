import 'package:doc_trial/bloc/user_bloc.dart';
import 'package:doc_trial/firebase_options.dart';
import 'package:doc_trial/route_generator.dart';
import 'package:doc_trial/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bloc/chat_bloc.dart';
import 'bloc/home_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDefault().then((value) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserBloc()),
          ChangeNotifierProvider(create: (context) => HomeBloc()),
          ChangeNotifierProvider(create: (context) => ChatBloc()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

Future<void> initializeDefault() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.blue,
          appBarTheme: const AppBarTheme(
              foregroundColor: Colors.blue,
              color: Colors.white,
              elevation: 0,
              centerTitle: true),
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
                  headline1:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  bodyText1:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 22))
              .apply(displayColor: Colors.white)),
      initialRoute:
          Provider.of<UserBloc>(context, listen: false).auth.currentUser == null
              ? Routes.loginScreen
              : Routes.homeScreen,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
