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
      appBar: AppBar(
        title: const Text('Deposit'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomField(hints: 'Insert value you want to deposit', textEditingController: depositCtrl, inputType: TextInputType.number,),
            const SizedBox(height: 16,),
            CustomButton(buttonText: "Submit", onButtonPress:() async{
              setState((){
                isLoading = true;
              });
              try{
                Utils.depositAccount(depositCtrl.text, context);
              }catch(e){
                Toast.show(e.toString(), duration: Toast.lengthShort);
              }finally{
                setState((){
                  isLoading = false;
                });
              }
            })
          ],
        ),
      ),
    );
  }


}
