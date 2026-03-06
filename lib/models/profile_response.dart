import 'dart:convert';

class ProfileResponse {
  int? statusCode;
  String? message;
  ProfileModel? data;

  ProfileResponse({this.statusCode, this.message, this.data});

  ProfileResponse copyWith({int? statusCode, String? message, ProfileModel? data}) => ProfileResponse(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory ProfileResponse.fromRawJson(String str) => ProfileResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileResponse.fromJson(Map<String, dynamic> json) => ProfileResponse(
    statusCode: json["statusCode"],
    message: json["message"],
    data: json["data"] == null ? null : ProfileModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"statusCode": statusCode, "message": message, "data": data?.toJson()};
}

class ProfileModel {
  String? username;
  DateTime? createdAt;

  ProfileModel({this.username, this.createdAt});

  ProfileModel copyWith({String? username, DateTime? createdAt}) =>
      ProfileModel(username: username ?? this.username, createdAt: createdAt ?? this.createdAt);

  factory ProfileModel.fromRawJson(String str) => ProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    username: json["username"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {"username": username, "createdAt": createdAt?.toIso8601String()};
}
