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
  String? id;
  String? username;
  String? publicKey;
  DateTime? createdAt;

  ProfileModel({this.id, this.username, this.publicKey, this.createdAt});

  ProfileModel copyWith({String? id, String? username, String? publicKey, DateTime? createdAt}) => ProfileModel(
    id: id ?? this.id,
    username: username ?? this.username,
    publicKey: publicKey ?? this.publicKey,
    createdAt: createdAt ?? this.createdAt,
  );

  factory ProfileModel.fromRawJson(String str) => ProfileModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    username: json["username"],
    publicKey: json["publicKey"],
    createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "publicKey": publicKey,
    "createdAt": createdAt?.toIso8601String(),
  };
}
