import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:la_casa_code_task/provider/doctors/doctor_provider.dart';
import 'package:la_casa_code_task/provider/doctors/doctors_provider.dart';

import '../../utils/help_functions.dart';
import '../widgets/doctor_card.dart';
import '../widgets/loading_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> getDoctors() async {
    try {
      LoadingScreen.show(context);
      await context.read<DoctorsProvider>().getDoctors();
      Navigator.of(context).pop();
    } on FirebaseException catch (e, s) {
      Navigator.of(context).pop();
      debugPrint(' error ${e.message}');
      debugPrint(' error $s}');
      HelpFunctions.showToast(e.message!, context);
    } catch (e, s) {
      debugPrint(' error $e');
      debugPrint(' error $s');
      Navigator.of(context).pop();
      HelpFunctions.showToast("SomeThing Went Wrong!", context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      getDoctors();
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctors = context.watch<DoctorsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome To Clinic Name"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: doctors.doctors.isEmpty
          ? const Center(
              child: Text("No Data Found"),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: doctors.doctors.length,
              itemBuilder: (context, int i) =>
                  ChangeNotifierProvider<DoctorProvider>(
                create: (_) => DoctorProvider(doctors.doctors[i]),
                child: const DoctorCard(),
              ),
            ),
    );
  }
}
