import 'dart:convert';
import 'package:doc_trial/models/user_model.dart';
import 'package:doc_trial/ws_response_model.dart';
import 'package:doc_trial/ws_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future getUserInformation(String? email) async {
    String url =
        'http://localhost:5001/doc-trial-2f6e0/us-central1/widgets/getLoggedInUser?id=$email';
    http.Response? response =
        await WsService().executeHttpRequest(url: url, method: HttpMethod.GET);
    if (response!.statusCode == 200) {
      try {
        return UserModel.fromJson(jsonDecode(response.body));
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception('a non 200 error');
    }
  }

  Future<WsResponseModel> registerUser(
      {required String name,
      required String email,
      required String age,
      required String id}) async {
    dynamic params = {"Name": name, "Email": email, "Age": age, "UserId": id};

    String url =
        'http://localhost:5001/doc-trial-2f6e0/us-central1/widgets/registerUser';
    http.Response? response = await WsService()
        .executeHttpRequest(url: url, method: HttpMethod.POST, body: params);
    if (response!.statusCode == 200) {
      try {
        return WsResponseModel(
            success: true,
            data: CreateAccountModel.fromJson(jsonDecode(response.body)));
      } catch (e) {
        throw WsResponseModel(success: false);
      }
    }
    return WsResponseModel(success: false);
  }
}
