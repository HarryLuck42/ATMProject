import 'package:atm_project/model/debt.dart';
import 'package:atm_project/widget/custom_button.dart';
import 'package:atm_project/widget/custom_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../utils.dart';


class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final auth = FirebaseAuth.instance;
  var isLoading = false;
  final transferCtrl = TextEditingController();
  final destinationCrtl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16,),
              CustomField(hints: "Username destination who's transferred", textEditingController: destinationCrtl),
              const SizedBox(height: 16,),
              CustomField(hints: 'Input your value that you want to transfer', textEditingController: transferCtrl, inputType: TextInputType.number,),
              const SizedBox(height: 16,),
              CustomButton(buttonText: 'Submit', onButtonPress: (){
                final String userId = auth.currentUser?.uid ?? '';
                Utils.transferMoney(destinationCrtl.text, transferCtrl.text, context);
              })
            ],
          ),
        ),
      ),
    );
  }


}
