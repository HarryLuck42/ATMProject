import 'package:atm_project/consts.dart';
import 'package:atm_project/utils.dart';
import 'package:atm_project/widget/custom_button.dart';
import 'package:atm_project/widget/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({Key? key}) : super(key: key);

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final depositCtrl = TextEditingController();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: purple,
      appBar: AppBar(
        title: const Text('Deposit',
            style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Value:",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              const SizedBox(
                height: 16,
              ),
              CustomField(
                hints: 'Insert value you want to deposit',
                textEditingController: depositCtrl,
                inputType: TextInputType.number,
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                  color: yellow,
                  textColor: Colors.black,
                  buttonText: "Submit",
                  onButtonPress: () async {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      Utils.depositAccount(depositCtrl.text, context);
                    } catch (e) {
                      Toast.show(e.toString(), duration: Toast.lengthShort);
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
