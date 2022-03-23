import 'package:flutter/foundation.dart';
import 'package:la_casa_code_task/model/user_model.dart';

export 'package:provider/provider.dart';

class DoctorProvider with ChangeNotifier {
  UserModel doctor;
  DoctorProvider(this.doctor);
}
