import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../model/user_model.dart';
import '../utils/vars.dart';

export 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool get isAuth => uid != null;

  String? get uid => auth.currentUser?.uid;

  User? get user => auth.currentUser;

  UserModel currentUser = UserModel();

  Future<void> logIn(String email, String password) async {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    //TODO check if empty
    final response =
        await firestore.collection(UserData.userDataTable).doc(uid).get();
    currentUser = UserModel.fromMap(response.data()!);
    notifyListeners();
  }

  /////////////////// Get user data //////////////////////////////

  Future<void> getUserData() async {
    final response =
        await firestore.collection(UserData.userDataTable).doc(uid).get();
    currentUser = UserModel.fromMap(response.data()!);
    notifyListeners();
  }

  //////////// Update User Data //////////////////////////////////////
  Future<void> updateUserData(UserModel userUpdates) async {
    await firestore
        .collection(UserData.userDataTable)
        .doc(uid)
        .update(userUpdates.toMap());
    currentUser = userUpdates;
    // await user.updateEmail(userUpdates.email);
    notifyListeners();
  }
///////////////////////////////////////////////////////////////////

  Future<void> signup(UserModel user, String pass, XFile profile) async {
    await auth.createUserWithEmailAndPassword(
      email: user.email,
      password: pass,
    );
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.absolute}/';
    Reference ref =
        FirebaseStorage.instance.ref().child(profile.path.split('/').last);

    await ref.putFile(
      File(profile.path),
    );

    user.imageUrl = await ref.getDownloadURL();

    user.userID = auth.currentUser!.uid;

    await firestore
        .collection(UserData.userDataTable)
        .doc(uid)
        .set(user.toMap());
    currentUser = user;

    notifyListeners();
  }

  bool tryAutoLogin() => isAuth;

  Future<void> logOut() async {
    await auth.signOut();
    currentUser = UserModel();

    notifyListeners();
  }

  Future<void> forgetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
    notifyListeners();
  }

  /////// Delete fireStore image ////////
  Future<void> deleteImage(String imagePath) async {
    await FirebaseStorage.instance.ref().child(imagePath).delete().whenComplete(
        () => debugPrint('Successfully deleted $imagePath storage item'));
  }
}
