import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:la_casa_code_task/model/user_model.dart';
import 'package:la_casa_code_task/utils/vars.dart';

export 'package:provider/provider.dart';

class DoctorsProvider with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<UserModel> doctors = [];

  Future<void> getDoctors() async {
    final data = await firestore.collection(UserData.userDataTable).get();
    if (data.docs.isNotEmpty) {
      print("isNotEmpty");
      for (var element in data.docs) {
        doctors.add(UserModel.fromMap(element.data()));
      }
    }
    print("UserModel");

    notifyListeners();
  }
}
