import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String? email;
  final String? name;
  final String? id;
  final String? pictureModel;

  Map<String, dynamic> toJson() => {
        'email': email,
        'name': name,
        'id': id,
        'pictureModel': pictureModel,
      };

  UserModel({this.email, this.id, this.name, this.pictureModel});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id'] as String?,
      name: json['name'],
      pictureModel: json['pictureModel'],
    );
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      name: snapshot["name"],
      pictureModel: snapshot["pictureModel"],
      id: snapshot["id"],
      email: snapshot["email"],
    );
  }
}
