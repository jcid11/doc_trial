class CreateAccountModel{
  final dynamic name;
  final dynamic email;
  final dynamic age;
  final dynamic id;

  CreateAccountModel({required this.name, required this.email, required this.age,required this.id});

  factory CreateAccountModel.fromJson(Map<String,dynamic>json)=>CreateAccountModel(name: json['Name'], email: json['Email'], age: json['Age'],id: json['UserId']);
}

class UserModel{
  final String name;
  final String email;
  final String age;

  UserModel({required this.name, required this.email, required this.age});

  factory UserModel.fromJson(Map<String,dynamic>json)=>UserModel(name: json['Name'], email: json['Email'], age: json['Age']);
}