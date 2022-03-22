import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:la_casa_code_task/ui/screens/main_screen.dart';

import '../../../model/user_model.dart';
import '../../../provider/auth_provider.dart';
import '../../../utils/help_functions.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/simple_textfield.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _autoValidate = false;
  String _password = "";
  UserModel user = UserModel();
  XFile? image;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _autoValidate = true);
      return;
    }
    _formKey.currentState!.save();
    try {
      if (image == null) {
        return HelpFunctions.showToast("choose profile image first!", context);
      }
      LoadingScreen.show(context);
      await context.read<AuthProvider>().signup(user, _password, image!);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e, s) {
      Navigator.of(context).pop();
      debugPrint(' error ${e.code}');
      debugPrint(' error $s}');
      HelpFunctions.showToast(e.message!, context);
    } catch (e, s) {
      debugPrint(' error ${e.toString()}');
      Navigator.of(context).pop();
      debugPrint(' error $s');
      HelpFunctions.showToast("Something Went Wrong!", context);
    }
  }

  Future<void> _chooseSource() async {
    await showDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text("Choose"),
        content: Column(
          children: <Widget>[
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _pickImage(true),
                  child: const Text("Camera"),
                  textColor: Colors.white,
                ),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () => _pickImage(false),
                  child: const Text("Gallery"),
                  textColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(bool isCamera) async {
    try {
      final ImagePicker _picker = ImagePicker();

      if (isCamera) {
        // Pick an image
        image = await _picker.pickImage(source: ImageSource.camera);
      } else {
        // Pick an image
        image = await _picker.pickImage(source: ImageSource.gallery);
      }
    } catch (e, s) {
      debugPrint("$e");
      debugPrint("$s");
    } finally {
      Navigator.pop(context);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 20,
            color: Color(0xff055261),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
        leading: const BackButton(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Column(
            children: [
              Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        if (image == null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: Alignment.center,
                              height: MediaQuery.of(context).size.height / 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white10),
                              ),
                              child: const Icon(Icons.person_rounded),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height / 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white10),
                                image: DecorationImage(
                                    image: Image.file(
                                      File(image!.path),
                                      height: height * 0.14,
                                      width: width * 0.31,
                                      fit: BoxFit.cover,
                                    ).image,
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        Positioned(
                          right: MediaQuery.of(context).size.width * 0.31,
                          top: MediaQuery.of(context).size.height * 0.11,
                          child: InkWell(
                            onTap: _chooseSource,
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white10),
                                  shape: BoxShape.circle,
                                  color: Colors.grey),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.photo_camera_rounded,
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SimpleTextField(
                      hintText: 'Name',
                      label: 'Name',
                      onSaved: (value) => user.name = value!,
                      validator: ValidationBuilder().required().build(),
                    ),
                    //////////////////////////////////////
                    SimpleTextField(
                      hintText: 'Email',
                      label: 'Email',
                      textInputType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      onSaved: (value) => user.email = value!,
                      validator: ValidationBuilder().required().email().build(),
                    ),
                    //////////////////////////////////////
                    SimpleTextField(
                      hintText: 'Password',
                      label: 'Password',
                      textInputType: TextInputType.visiblePassword,
                      obSecure: true,
                      onSaved: (value) => _password = value!,
                      validator:
                          ValidationBuilder().required().minLength(6).build(),
                    ),
                    //////////////////////////////////////
                    SimpleTextField(
                      hintText: 'Phone Number',
                      label: 'Phone Number',
                      textInputType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onSaved: (value) => user.number = value!,
                      validator: ValidationBuilder().required().build(),
                    ),
                    //////////////////////////////////////
                    SimpleTextField(
                      hintText: 'Speciality',
                      label: 'Speciality',
                      onSaved: (value) => user.speciality = value!,
                      validator:
                          ValidationBuilder().required().minLength(12).build(),
                    ),
                    //////////////////////////////////////
                    SimpleTextField(
                      hintText: 'About Me',
                      label: 'About Me',
                      maxLines: 3,
                      onSaved: (value) => user.aboutMe = value!,
                      validator:
                          ValidationBuilder().required().minLength(12).build(),
                    ),

                    //////////////////////////////////////
                  ],
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              CustomButton(
                title: 'Sign Up',
                function: () => _submit(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
