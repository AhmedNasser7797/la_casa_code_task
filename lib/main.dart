import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:la_casa_code_task/provider/auth_provider.dart';
import 'package:la_casa_code_task/provider/doctors/doctors_provider.dart';
import 'package:la_casa_code_task/ui/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (BuildContext context) => AuthProvider(),
        ),
        ChangeNotifierProvider<DoctorsProvider>(
          create: (BuildContext context) => DoctorsProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: SplashScreen(auth: auth),
        ),
      ),
    );
  }
}
