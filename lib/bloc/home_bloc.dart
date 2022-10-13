import 'package:doc_trial/service/home_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../models/home_model.dart';
import '../service/user_service.dart';

class HomeBloc with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  bool searchButtonActivation = false;
  bool isUsersLoading = true;
  String searchWord = '';
  List<GetUsersModel> usersList = [];
  List<GetUsersModel> searchedList = [];

  void searchReset() {
    searchWord = '';
    notifyListeners();
  }

  void setSearchWord(String word) {
    if (word.isNotEmpty) {
      searchWord = word;
      searchedList =
          searchedList.where((element) => element.name.contains(word)).toList();
    } else {
      searchedList = usersList;
    }
    notifyListeners();
  }

  Future getUsers() async {
    await HomeService().getAllUsers().then((value) {
      usersList = value;
      searchedList = value;
      isUsersLoading = false;
      notifyListeners();
    });
  }



  void toggleSearchButton() {
    searchButtonActivation = !searchButtonActivation;
    notifyListeners();
  }
}
