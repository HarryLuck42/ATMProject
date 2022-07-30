
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import 'model/account.dart';
import 'model/debt.dart';

class Utils{

  static void loginUser(String password, String email, Function(UserCredential user) getUser, Function() finalState, BuildContext context) async {
    final auth = FirebaseAuth.instance;
    try {
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        getUser(user);

      } else {
        throw "user is null";
      }
    } catch (e) {
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }finally{
      finalState();
    }
  }

  static void registerUser(String username, String password, String email, Function() finalState, Function() nextPage, BuildContext? context) async{
    final auth = FirebaseAuth.instance;
    try{
      if(password.length <= 5){
        throw "Password should be at least 6 characters";
      }
      getTableAccount((data) async{
        try{
          if(data != null){

            final String checkUser = data.data()['username'];
            if(username == checkUser){
              throw "Username has existed";
            }else{
              final newUser = await auth.createUserWithEmailAndPassword(
                  email: email, password: password);
              if(newUser != null){
                if(newUser.user != null){
                  await saveUser(newUser.user!, username,(){});
                  nextPage();
                }else{
                  throw "User is null";
                }
              }else{
                throw "User is null";
              }

            }
          }else{
            final newUser = await auth.createUserWithEmailAndPassword(
                email: email, password: password);
            if(newUser != null){
              if(newUser.user != null){
                await saveUser(newUser.user!, username,(){});
                nextPage();
              }else{
                throw "User is null";
              }
            }else{
              throw "User is null";
            }
          }
        }catch(e){
          Toast.show(e.toString(), duration: Toast.lengthLong);
        }
      }, 'username', username, context);

    }catch(e){
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }finally{
      finalState();
    }
  }

  static Future<void> saveUser(User loggedInUser, String username, Function() finalState ) async{
  final store = FirebaseFirestore.instance;

    try{
      var data = Account();
      data.idUser = loggedInUser.uid;
      data.username = username;
      data.email = loggedInUser.email;
      data.deposit = 0;

      await store.collection("account").add(data.toJson());
    }catch(e){
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }finally{
      finalState();
    }
  }

  static void streamTableAccount(Function(QueryDocumentSnapshot<Map<String, dynamic>> data) func, BuildContext context) async{
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    ToastContext().init(context);
    try{
      final snaps = store.collection('account').where("uid_user", isEqualTo: auth.currentUser?.uid).snapshots();
      await for(var snap in snaps){
        snap.docs.forEach((doc) {
          func(doc);
        });
      }
    }catch(e){
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }
  }
  static void getTableAccount(Function(QueryDocumentSnapshot<Map<String, dynamic>>? data) func, String? where, String? value, BuildContext? context) async{
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    try {
      print(auth.currentUser?.uid);
      store.collection("account").where(where ?? "uid_user", isEqualTo: value ?? auth.currentUser?.uid).get().then((value){
        if(value.docs.isEmpty){
          func(null);
        }else{
          value.docs.forEach((doc){
            func(doc);
          });
        }

      });

    } catch (e) {
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }
  }

  static void streamDebts(Function(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) func, BuildContext context) async{
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    ToastContext().init(context);
    try{
      final snaps = store.collection('debt').where("user_id", isEqualTo: auth.currentUser?.uid).snapshots();
      await for(var snap in snaps){
        func(snap.docs);
      }
    }catch(e){
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }
  }

  static void getTableDebt(Function(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) func, BuildContext context) async{
    final auth = FirebaseAuth.instance;
    final store = FirebaseFirestore.instance;
    ToastContext().init(context);
    try {
      print(auth.currentUser?.uid);
      var transaction = store.collection("debt").where("user_id", isEqualTo: auth.currentUser?.uid);
      transaction.get().then((value){
        func(value.docs);
      });

    } catch (e) {
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }
  }

  static void getTableAnotherDebt(Function(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) func, String uid, String username, BuildContext context) async{
    final store = FirebaseFirestore.instance;
    ToastContext().init(context);
    try {
      var transaction = store.collection("debt").where("user_id", isEqualTo: uid).where("username", isEqualTo: username);
      transaction.get().then((value){
        func(value.docs);
      });

    } catch (e) {
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }
  }

  static void addDebt(Debt debt, BuildContext context) async{
    final store = FirebaseFirestore.instance;
    ToastContext().init(context);
    try{
      await store.collection("debt").add(debt.toJson());
    }catch(e){
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }
  }


  //====deposito functions====
  static void depositAccount(String deposit, BuildContext context){
    int fixDeposit = int.parse(deposit);
    Utils.getTableAccount((myAccount) async{
      depositGetDept(myAccount, fixDeposit, context);
    }, null, null, context);
  }

  static void depositGetDept(QueryDocumentSnapshot<Map<String, dynamic>>? myAccount, int fixDeposit, BuildContext context){
    Utils.getTableDebt((debts) async{
      try{
        final int currentDeposit = myAccount?.data()['deposit'];
        if(debts.length > 0){
          depositGetFriendAccount(debts, myAccount, fixDeposit, currentDeposit, context);
        }else{
          await myAccount?.reference.update({'deposit': (fixDeposit + currentDeposit)});
          Navigator.pop(context);
        }
      }catch(e){
        Toast.show(e.toString(), duration: Toast.lengthLong);
      }

    }, context);
  }

  static void depositGetFriendAccount(List<QueryDocumentSnapshot<Map<String, dynamic>>> debts, QueryDocumentSnapshot<Map<String, dynamic>>? myAccount, int fixDeposit, int currentDeposit, BuildContext context){
    for(var debt in debts){
      Utils.getTableAccount((myFriend) async{
        try{
          final int currentDebt = debt.data()['debt'];
          final int currentMyFriend = myFriend?.data()['deposit'];
          // final int usernameMyFriend = myFriend.data()['username'];
          if(currentDebt > fixDeposit){
            await debt.reference.update({'debt': (currentDebt - fixDeposit)});

            updateDebt(myFriend, myAccount, (currentDebt - fixDeposit), context);
            await myFriend?.reference.update({'deposit' : (currentMyFriend + fixDeposit)});
            Navigator.pop(context);
          }else if(currentDebt == fixDeposit){
            await debt.reference.delete();
            deleteDebt(myFriend, myAccount, context);
            await myAccount?.reference.update({'deposit': 0});
            await myFriend?.reference.update({'deposit' : (fixDeposit)});
            Navigator.pop(context);
          }else{
            final int index = debts.indexOf(debt);
            if(index == (debts.length - 1)){
              await debt.reference.delete();
              deleteDebt(myFriend, myAccount, context);
              final result = currentDeposit + (fixDeposit - currentDebt);
              await myAccount?.reference.update({'deposit': (result)});
              await myFriend?.reference.update({'deposit' : (currentDebt)});
            }else{
              await debt.reference.delete();
              deleteDebt(myFriend, myAccount, context);
              fixDeposit -= currentDebt;
              await myAccount?.reference.update({'deposit': (fixDeposit)});
              await myFriend?.reference.update({'deposit' : (currentDebt)});
            }
            Navigator.pop(context);
          }
        }catch(e){
          Toast.show(e.toString(), duration: Toast.lengthLong);
        }

      }, 'username', debt.data()['username'], context);
    }

  }

  static void deleteDebt(QueryDocumentSnapshot<Map<String, dynamic>>? myFriend, QueryDocumentSnapshot<Map<String, dynamic>>? myAccount, BuildContext context){
    try{
      Utils.getTableAnotherDebt((data) async{
        for(var a in data){
          a.reference.delete();
        }
      }, myFriend?.data()['uid_user'], myAccount?.data()['username'], context);
    }catch(e){
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }
  }

  static void updateDebt(QueryDocumentSnapshot<Map<String, dynamic>>? myFriend, QueryDocumentSnapshot<Map<String, dynamic>>? myAccount, int value, BuildContext context){
    try{
      Utils.getTableAnotherDebt((data) async{
        for(var a in data){
          a.reference.update({'debt': value});
        }
      }, myFriend?.data()['uid_user'], myAccount?.data()['username'], context);
    }catch(e){
      Toast.show(e.toString(), duration: Toast.lengthLong);
    }
  }


  //====transfer functions====
  static void transferMoney(String destination, String transactionValue, BuildContext context)async{
    Utils.getTableAccount((myFriend){
      try{
        final String? userDestination = myFriend?.data()['username'];
        if(userDestination != null){
          getMyAccount(myFriend, transactionValue, context);
        }else{
          throw 'Please input right username destination';
        }
      }catch(e){
        Toast.show(e.toString(), duration: Toast.lengthLong);
      }

    }, 'username', destination, context);
  }

  static void getMyAccount(QueryDocumentSnapshot<Map<String, dynamic>>? myFriend, String transactionValue, BuildContext context){
    Utils.getTableAccount((myUser){
      int currentDeposit = myUser?.data()['deposit'];
      try{
        int transaction = int.parse(transactionValue);
        if(currentDeposit >= transaction){
          currentDeposit -= transaction;
          myAnotherDebt(myFriend, myUser, transaction, currentDeposit, context);
          friendAnotherDebt(myFriend, myUser, transaction, context);
          // Utils.getTableAnotherDebt((userDebt) async{
          //   if(userDebt.isEmpty){
          //     await myUser?.reference.update({'deposit': currentDeposit});
          //   }else{
          //     userDebt.forEach((element) async{
          //       int currentDebt = element.data()['debt'];
          //       if(currentDebt == transaction){
          //         await element.reference.delete();
          //       }else{
          //         await element.reference.update({'debt': currentDebt - transaction});
          //       }
          //     });
          //   }
          // }, myUser?.data()['uid_user'], myFriend?.data()['username'], context);
          // Utils.getTableAnotherDebt((friendDebt) async{
          //   if(friendDebt.isEmpty){
          //     final myFriendDeposit = myFriend?.data()['deposit'] + transaction;
          //     await myFriend?.reference.update({'deposit': myFriendDeposit});
          //   }else{
          //     friendDebt.forEach((element) async{
          //       int currentDebt = element.data()['debt'];
          //       if(currentDebt == transaction){
          //         await element.reference.delete();
          //       }else{
          //         await element.reference.update({'debt': currentDebt - transaction});
          //       }
          //     });
          //   }
          //
          // }, myFriend?.data()['uid_user'], myUser?.data()['username'], context);


          Navigator.pop(context);
        }else{
          final debtValue = transaction - currentDeposit;
          myUser?.reference.update({'deposit': 0});
          final myFriendDeposit = myFriend?.data()['deposit'] + currentDeposit;
          myFriend?.reference.update({'deposit': myFriendDeposit});
          final debt = Debt();
          debt.userId = myUser?.data()['uid_user'];
          debt.username = myFriend?.data()['username'];
          debt.debt = debtValue;
          Utils.addDebt(debt, context);
          debt.userId = myFriend?.data()['uid_user'];
          debt.username = myUser?.data()['username'];
          debt.debt = debtValue;
          Utils.addDebt(debt, context);
          Navigator.pop(context);
        }
      }catch(e){
        Toast.show(e.toString(), duration: Toast.lengthLong);
      }
    }, null, null, context);
  }

  static void myAnotherDebt(QueryDocumentSnapshot<Map<String, dynamic>>? myFriend, QueryDocumentSnapshot<Map<String, dynamic>>? myUser, int transaction, int currentDeposit, BuildContext context){
    Utils.getTableAnotherDebt((userDebt) async{
      try{
        if(userDebt.isEmpty){
          await myUser?.reference.update({'deposit': currentDeposit});
        }else{
          userDebt.forEach((element) async{
            int currentDebt = element.data()['debt'];
            if(currentDebt == transaction){
              await element.reference.delete();
            }else{
              await element.reference.update({'debt': currentDebt - transaction});
            }
          });
        }
      }catch(e){
        Toast.show(e.toString(), duration: Toast.lengthLong);
      }
    }, myUser?.data()['uid_user'], myFriend?.data()['username'], context);
  }

  static void friendAnotherDebt(QueryDocumentSnapshot<Map<String, dynamic>>? myFriend, QueryDocumentSnapshot<Map<String, dynamic>>? myUser, int transaction, BuildContext context){
    Utils.getTableAnotherDebt((friendDebt) async{
      try{
        if(friendDebt.isEmpty){
          final myFriendDeposit = myFriend?.data()['deposit'] + transaction;
          await myFriend?.reference.update({'deposit': myFriendDeposit});
        }else{
          friendDebt.forEach((element) async{
            int currentDebt = element.data()['debt'];
            if(currentDebt == transaction){
              await element.reference.delete();
            }else{
              await element.reference.update({'debt': currentDebt - transaction});
            }
          });
        }
      }catch(e){
        Toast.show(e.toString(), duration: Toast.lengthLong);
      }
    }, myFriend?.data()['uid_user'], myUser?.data()['username'], context);
  }
}
