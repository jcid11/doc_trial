import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bloc/user_bloc.dart';
import '../utils/routes.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(child: Container()),
          TextButton(onPressed: ()=>Provider.of<UserBloc>(context, listen: false).signOut().then((value) {
            Navigator.pushReplacementNamed(context, Routes.loginScreen);
          }), child: const Text("Logout")),
          const SizedBox(height: 5,)
        ],
      ),
    );
  }
}
