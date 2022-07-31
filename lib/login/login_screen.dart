import 'package:atm_project/app.dart';
import 'package:atm_project/helper/auth.dart';
import 'package:atm_project/register/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';

import '../consts.dart';
import '../main/atm_main_screen.dart';
import '../widget/custom_button.dart';
import '../widget/custom_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = Auth(auth: FirebaseAuth.instance);

  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SvgPicture.asset(
                iconCreditCard,
                width: 150,
                height: 150,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                key: App.keyEmailLogin,
                hints: "email",
                textEditingController: usernameCtrl,
                inputType: TextInputType.emailAddress,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                key: App.keyPasswordLogin,
                hints: "password",
                textEditingController: passwordCtrl,
                isPassword: true,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                key: App.keyLoginButton,
                buttonText: "Login",
                onButtonPress: () async {
                  // print(usernameCtrl.text);
                  // print(passwordCtrl.text);
                  setState(() {
                    isLoading = true;
                  });
                  var message = await auth
                      .loginUser(passwordCtrl.text, usernameCtrl.text, (user) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return AtmMainScreen();
                    }));
                  }, () {
                    setState(() {
                      isLoading = false;
                    });
                  });
                  Toast.show(message, duration: Toast.lengthShort);
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RegisterScreen();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    "Please click here, if you've not registered yet.",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
