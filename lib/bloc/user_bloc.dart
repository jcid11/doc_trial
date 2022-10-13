import 'package:doc_trial/service/user_service.dart';
import 'package:doc_trial/ws_response_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserBloc with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  WsResponseModel register = WsResponseModel(success: false);
  bool loadingFirebaseUserCreation = true;
  bool loadingBackendUserCreation = true;
  bool loadingUserEmail = true;
  String id = '';
  String loggedInUserId = '';
  String userEmail = '';
  String userName = '';

  Future registerUser(
      {required String name,
      required String email,
      required String age,
      required String password}) async {
    await registerUserInFirebase(email, password).then((value) {
      loadingFirebaseUserCreation = false;
      auth.signOut();
    });
    if (!loadingFirebaseUserCreation) {
      await registerUserInBackEnd(
              name: name, email: email, age: age, userID: id)
          .then((value) => loadingBackendUserCreation = false);
    }
    if (!loadingFirebaseUserCreation && !loadingBackendUserCreation) {
      return register;
    }
  }

  Future<WsResponseModel> registerUserInBackEnd(
      {required String name,
      required String email,
      required String age,
      required String userID}) async {
    register = await UserService()
        .registerUser(name: name, email: email, age: age, id: userID);
    return register;
  }

  Future registerUserInFirebase(String email, String password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => id = value.user!.uid);
    } catch (e) {
      throw Exception('eeee $e');
    }
  }

  Future assignUserEmail() async {
    await UserService()
        .getUserInformation(auth.currentUser!.email)
        .then((value) {
          userName =value.name;
      userEmail = value.email;
      loadingUserEmail = false;
    });
  }

  Future signIn(String email, String password) async {
    return await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => loggedInUserId = value.user!.uid);
  }

  Future signOut() async {
    await auth.signOut();
  }
}
