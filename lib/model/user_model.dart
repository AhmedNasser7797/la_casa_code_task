import 'package:flutter/cupertino.dart';

import '../utils/vars.dart';

class UserModel {
  String userID = "";
  String email = "";
  String name = "";
  String number = "";
  String imageUrl = "";
  // String imagePath = "";
  String speciality = "";
  String aboutMe = "";

  UserModel();
//   UserModel({
//     required this.imageUrl,
//     required this.name,
//     required this.email,
//     required this.imagePath,
//     required this.number,
//     required this.userID,
// });
  UserModel.fromMap(Map<String, dynamic> m) {
    email = m[UserData.email];
    name = m[UserData.name];
    number = m[UserData.phoneNumber];
    imageUrl = m[UserData.imageUrl];
    // imagePath = m[UserData.imagePath];
    userID = m[UserData.id];
    speciality = m[UserData.speciality];
    aboutMe = m[UserData.aboutMe];
    debugPrint("******************** get user data **************");
    debugPrint("email : $email");
    debugPrint("name : $name");
    debugPrint("number : $number");
    debugPrint("imageUrl : $imageUrl");
    // debugPrint("imagePath : $imagePath");
    debugPrint("userID : $userID");
    debugPrint("speciality : $speciality");
    debugPrint("aboutMe : $aboutMe");
  }

  Map<String, dynamic> toMap() {
    return {
      UserData.email: email,
      UserData.name: name,
      UserData.phoneNumber: number,
      UserData.imageUrl: imageUrl,
      // UserData.imagePath: imagePath,
      UserData.id: userID,
      UserData.speciality: speciality,
      UserData.aboutMe: aboutMe,
    };
  }
}
