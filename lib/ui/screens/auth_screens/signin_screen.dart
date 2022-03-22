import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:la_casa_code_task/ui/screens/auth_screens/signup_screen.dart';
import 'package:la_casa_code_task/ui/screens/main_screen.dart';

import '../../../provider/auth_provider.dart';
import '../../../utils/help_functions.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/simple_textfield.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _autoValidate = false;
  String _email = "", _password = "";

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      if (mounted) {
        setState(() {
          _autoValidate = true;
        });
      }
      return;
    }
    _formKey.currentState!.save();

    try {
      LoadingScreen.show(context);

      await context.read<AuthProvider>().logIn(_email, _password);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e, s) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 36,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SimpleTextField(
                      onSaved: (value) => _email = value!,
                      autofillHints: const [AutofillHints.email],
                      textInputType: TextInputType.emailAddress,
                      validator: ValidationBuilder().required().email().build(),
                      hintText: 'Email',
                      label: "Email",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SimpleTextField(
                      onSaved: (value) => _password = value!,
                      validator:
                          ValidationBuilder().required().minLength(6).build(),
                      obSecure: true,
                      hintText: 'Password',
                      label: "Password",
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ////////////

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          // onTap: () {
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             ForgetPasswordScreen()),
                          //   );
                          // },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 10.0),
                            child: Text(
                              'Forget Password?',
                              style: TextStyle(
                                fontFamily: 'SF Pro Display',
                                fontSize: 12,
                                color: Color(0xccff5858),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //////////////////////////////////////////////
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomButton(
                title: 'Sign In',
                function: () => _submit(),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 24),
                    child: Text(
                      'Have no account yet.?!',
                      style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 12,
                        color: Color(0x99055261),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen())),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 41, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: const Color(0x00055261),
                        border: Border.all(
                            width: 1.0, color: const Color(0xff055261)),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 16,
                          color: Color(0xff055261),
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
