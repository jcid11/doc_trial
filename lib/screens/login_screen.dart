import 'package:doc_trial/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../utils/routes.dart';
import '../widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Lottie.asset('assets/lottie/hello.json',
                    width: 250, height: 250),
                loginTextField(controller: email, title: 'Enter your email'),
                const SizedBox(
                  height: 10,
                ),
                loginTextField(controller: password, title: 'Password'),
                const SizedBox(
                  height: 30,
                ),
                generalButton(context, 'Login', () {
                  showLoading(context, title: 'Please wait...');
                  Provider.of<UserBloc>(context, listen: false)
                      .signIn(email.text, password.text)
                      .then((value) {
                    if (context.read<UserBloc>().auth.currentUser != null) {
                      Navigator.pop(context);
                      showSnackBar(context, 'You have successfully login');
                      Navigator.pushNamed(context, Routes.homeScreen);
                    } else {
                      Navigator.pop(context);
                      showSnackBar(context, 'An error has occurred');
                    }
                  });
                }),
                TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text('Register')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget loginTextField(
    {required TextEditingController controller, required String title}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      //fillColor: Color(0XFFf4f4f4),
      filled: true,
      hintText: title,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 19.0, horizontal: 30.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
    ),
  );
}
