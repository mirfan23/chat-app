import 'dart:convert';

class AllUserResponse {
  int? statusCode;
  String? message;
  List<AllUserModel>? data;

  AllUserResponse({this.statusCode, this.message, this.data});

  AllUserResponse copyWith({int? statusCode, String? message, List<AllUserModel>? data}) => AllUserResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory AllUserResponse.fromRawJson(String str) => AllUserResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllUserResponse.fromJson(Map<String, dynamic> json) => AllUserResponse(
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AllUserModel>.from(json["data"]!.map((x) => AllUserModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AllUserModel {
  String? username;
  bool? isOnline;

  AllUserModel({this.username, this.isOnline});

  AllUserModel copyWith({String? username, bool? isOnline}) =>
      AllUserModel(username: username ?? this.username, isOnline: isOnline ?? this.isOnline);

  factory AllUserModel.fromRawJson(String str) => AllUserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AllUserModel.fromJson(Map<String, dynamic> json) =>
      AllUserModel(username: json["username"], isOnline: json["isOnline"]);

  Map<String, dynamic> toJson() => {"username": username, "isOnline": isOnline};
}
