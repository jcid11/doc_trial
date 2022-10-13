import 'dart:convert';
import 'package:doc_trial/models/home_model.dart';
import 'package:doc_trial/ws_service.dart';
import 'package:http/http.dart' as http;

class HomeService {
  Future getAllUsers() async{
    String url =
        'http://localhost:5001/doc-trial-2f6e0/us-central1/widgets/getUsers';

    http.Response? response =
        await WsService().executeHttpRequest(url: url, method: HttpMethod.GET);
    List<GetUsersModel> usersList = [];
    List jsonList = jsonDecode(response!.body) as List;
    if (response.statusCode == 200) {
      for (var element in jsonList) {
        var users = GetUsersModel(
            name: element['Name'],
            email: element['Email'],
            age: element['Age']);
        usersList.add(users);
      }
    }
    //como aca lo unico que hace es la llamada al backend por eso no utilizo mi wsresponsemodel... ese objeto es mas utilizado donde
    // se necesita una validacion y el usuario necesita algun tipo de respuesta de que esa pasando
    return usersList;
  }
}
