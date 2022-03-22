import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:la_casa_code_task/ui/screens/main_screen.dart';

import '../../provider/auth_provider.dart';
import '../../utils/help_functions.dart';
import '../widgets/loading_widget.dart';
import 'auth_screens/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  final AuthProvider? auth;

  const SplashScreen({Key? key, this.auth}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _checkAuth() async {
    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      if (widget.auth!.isAuth) {
        await context.read<AuthProvider>().getUserData();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
            (route) => false);
      }
    } on FirebaseException catch (e, s) {
      HelpFunctions.showToast(e.message!, context);
      debugPrint("uploadFile $e");
      debugPrint("uploadFile $s");
    } catch (e, s) {
      HelpFunctions.showToast("message error", context);
      debugPrint("uploadFile $e");
      debugPrint("uploadFile $s");
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: LoadingWidget(),
      ),
    );
  }
}
