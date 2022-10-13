import 'package:doc_trial/bloc/user_bloc.dart';
import 'package:doc_trial/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              registrationTextField(name, 'Name', context),
              const SizedBox(
                height: 10,
              ),
              registrationTextField(email, 'Email', context,
                  fieldValidator: (value) {
                if (!isEmailValid(email.text)) {
                  return '**Enter a valid email';
                } else if (value.toString().trim().isEmpty) {
                  return '**Field required';
                }
                return null;
              }),
              const SizedBox(
                height: 10,
              ),
              registrationTextField(age, 'Age', context,
                  fieldValidator: null, numericKeyboard: true),
              Expanded(child: Container()),
              generalButton(context, 'Register', () {
                if (_formKey.currentState!.validate()) {
                  showLoading(context, title: 'Please wait...');
                    Provider.of<UserBloc>(context, listen: false)
                        .registerUser(
                        name: name.text,
                        email: email.text,
                        age: age.text,
                        password: name.text)
                        .then((value) {
                      if (value.success) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        showSnackBar(context, 'User registered successfully');
                      } else {
                        Navigator.pop(context);
                        showSnackBar(context, 'An error has occurred');
                      }
                    });
                }
              }),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}

bool isEmailValid(String email) {
  return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);
}

Widget registrationTextField(var controller, String label, BuildContext context,
    {bool obscureText = false,
    bool requiredValidator = true,
    FormFieldValidator<String>? fieldValidator,
    bool numericKeyboard = false}) {
  return TextFormField(
    obscureText: obscureText,
    keyboardType: numericKeyboard ? TextInputType.number : null,
    style: const TextStyle(
        color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500),
    validator: fieldValidator != null
        ? (v) => fieldValidator(v)
        : requiredValidator
            ? (value) {
                if (value.toString().trim().isEmpty) {
                  return "**Field required";
                }
                return null;
              }
            : null,
    controller: controller,
    decoration: InputDecoration(
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
      ),
      labelText: '$label *',
      labelStyle: Theme.of(context)
          .textTheme
          .headline5!
          .copyWith(fontSize: 17, color: const Color(0xff616161)),
    ),
  );
}
