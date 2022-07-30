import 'package:atm_project/main/atm_main_screen.dart';
import 'package:atm_project/widget/custom_button.dart';
import 'package:atm_project/widget/custom_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';

import '../utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth = FirebaseAuth.instance;
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
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                hints: "email",
                textEditingController: emailCtrl,
                inputType: TextInputType.emailAddress,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                hints: "username",
                textEditingController: usernameCtrl,
                inputType: TextInputType.text,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                hints: "password",
                textEditingController: passwordCtrl,
                isPassword: true,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                  buttonText: "Register",
                  onButtonPress: () async {
                    // print(usernameCtrl.text);
                    // print(passwordCtrl.text);
                    setState(() {
                      isLoading = true;
                    });
                    Utils.registerUser(usernameCtrl.text, passwordCtrl.text, emailCtrl.text,
                        () {
                      setState(() {
                        isLoading = false;
                      });
                    }, () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return AtmMainScreen();
                      }));
                    }, context);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
