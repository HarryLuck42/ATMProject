import 'dart:ffi';

import 'package:atm_project/login/login_screen.dart';
import 'package:atm_project/model/account.dart';
import 'package:atm_project/utils.dart';
import 'package:atm_project/widget/custom_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:toast/toast.dart';

import '../deposit/deposit_screen.dart';
import '../model/debt.dart';
import '../transfer/transfer_screen.dart';

class AtmMainScreen extends StatefulWidget {
  static const String id = "atm_main_screen";
  const AtmMainScreen({Key? key}) : super(key: key);

  @override
  State<AtmMainScreen> createState() => _AtmMainScreenState();
}

class _AtmMainScreenState extends State<AtmMainScreen> {
  final auth = FirebaseAuth.instance;
  final store = FirebaseFirestore.instance;
  late User loggedInUser;
  var isLoading = false;
  var account = Account();
  List<Debt> debts = [];

  @override
  void initState() {
    super.initState();

    if(auth.currentUser != null){
      loggedInUser = auth.currentUser!;
      getCurrentUser();
      getAllDebts();
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return LoginScreen();
      }));
    }
  }

  void getCurrentUser() async {
    Utils.streamTableAccount((data){
      setState((){
        account.idUser = data.data()['user_id'];
        account.email = data.data()['email'];
        account.username = data.data()['username'];
        account.deposit = data.data()['deposit'];
      });
    }, context);
  }

  void updateDeposit(int deposit) async{
    Utils.getTableAccount((data){
      data?.reference.update({'deposit': deposit});
    }, null, null, context);
  }

  void getAllDebts(){
    Utils.streamDebts((data){
      setState((){
        debts.clear();
        if(data.length > 0){
          data.forEach((element) {
            final debt = Debt();
            debt.userId = element.data()['user_id'];
            debt.username = element.data()['username'];
            debt.debt = element.data()['debt'];
            debts.add(debt);
          });
        }
      });
    }, context);
  }


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: [
          IconButton(
              onPressed: () async{
                setState((){
                  isLoading = true;
                });
                try{
                  await auth.signOut();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return LoginScreen();
                  }));
                }catch(e){
                  Toast.show(e.toString(), duration: Toast.lengthShort);
                }finally{
                  setState((){
                    isLoading = false;
                  });
                }

              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),),
        ],
        title: const Text('Welcome My ATM'),

      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 30),
                width: double.infinity,
                child: Text("Email: ${account.email ?? ''}", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                width: double.infinity,
                child: Text("Username: ${account.username ?? ''}", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                width: double.infinity,
                child: Text("Balance: ${account.deposit ?? 'no deposit'}", textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(buttonText: "Deposit", onButtonPress: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return DepositScreen();
                      }));
                    }),
                    const SizedBox(width: 20,),
                    CustomButton(buttonText: "Transfer", onButtonPress: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return TransferScreen();
                      }));
                    })
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              debts.length > 0 ?
              Column(
                children: debts.map((e) => Container(
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text("Owed \$ ${e.debt} to"),
                          Text("${e.username}"),
                          const SizedBox(height: 10,),

                        ],
                      ),
                    ),
                  ),
                )).toList(),
              ) : const Text("You don't have any debts")
            ],
          ),
        ),
      ),
    );
  }
}
