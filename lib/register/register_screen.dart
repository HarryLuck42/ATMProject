import 'package:atm_project/app.dart';
import 'package:atm_project/helper/auth.dart';
import 'package:atm_project/main/atm_main_screen.dart';
import 'package:atm_project/widget/custom_button.dart';
import 'package:atm_project/widget/custom_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';

import '../consts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = Auth(auth: FirebaseAuth.instance);
  final store = FirebaseFirestore.instance;
  TextEditingController emailCtrl = TextEditingController();
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
              const SizedBox(
                height: 16,
              ),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                key: App.keyEmailRegis,
                hints: "email",
                textEditingController: emailCtrl,
                inputType: TextInputType.emailAddress,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                key: App.keyUsernameRegis,
                hints: "username",
                textEditingController: usernameCtrl,
                inputType: TextInputType.text,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                key: App.keyPasswordRegis,
                hints: "password",
                textEditingController: passwordCtrl,
                isPassword: true,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                key: App.keyRegisButton,
                buttonText: "Register",
                onButtonPress: () async {
                  // print(usernameCtrl.text);
                  // print(passwordCtrl.text);
                  setState(() {
                    isLoading = true;
                  });
                  final message = await auth.registerUser(
                      usernameCtrl.text, passwordCtrl.text, emailCtrl.text,
                      (user) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const AtmMainScreen();
                    }));
                  }, () {
                    setState(() {
                      isLoading = false;
                    });
                  }, context);
                  Toast.show(message, duration: Toast.lengthShort);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
