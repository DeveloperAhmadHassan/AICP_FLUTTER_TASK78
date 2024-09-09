import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser{
  String? uid;
  String? email;
  Map<String, dynamic>? phone;
  Gender? gender;
  String? birthdate;
  String? userName;
  String? city;
  String? address;
  String? profilePicUrl;
  String? type;
  bool isAnonymous = false;
  DateTime? createdAt;
  Map<String, dynamic>? name;

  AppUser({
    this.uid,
    this.email,
    this.phone,
    this.gender,
    this.birthdate,
    this.userName,
    this.profilePicUrl,
    this.city,
    this.address,
    this.type,
    this.createdAt,
    this.isAnonymous = false,
    this.name
  });

  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      uid: doc.id,
      email: doc['email'],
      userName: doc['username'],
      city: doc['city'],
      address: doc['address'],
      type: doc['userType'],
      createdAt: (doc['createdAt'] as Timestamp).toDate(),
      profilePicUrl: doc['profileImageUrl'] ?? '',
      phone: doc['phone'] ?? {},
      name: doc['name'] ?? {}
    );
  }
}

enum Gender{
  male,
  female,
  other
}