import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth auth;

  Auth({required this.auth});

  Stream<User?> get user => auth.authStateChanges();

  Future<String> registerUser(
      String username,
      String password,
      String email,
      Function(User?) nextPage,
      Function() finalState,
      BuildContext? context) async {
    // final auth = FirebaseAuth.instance;
    try {
      if (password.length <= 5) {
        throw "Password should be at least 6 characters";
      }
      Utils.getTableAccount((data) async {
        try {
          if (data != null) {
            final String checkUser = data.data()['username'];
            if (username == checkUser) {
              throw "Username has existed";
            } else {
              final newUser = await auth.createUserWithEmailAndPassword(
                  email: email, password: password);
              if (newUser != null) {
                if (newUser.user != null) {
                  await Utils.saveUser(newUser.user!, username, () {});
                  nextPage(newUser.user);
                } else {
                  throw "User is null";
                }
              } else {
                throw "User is null";
              }
            }
            return 'Success';
          } else {
            final newUser = await auth.createUserWithEmailAndPassword(
                email: email, password: password);
            if (newUser != null) {
              if (newUser.user != null) {
                await Utils.saveUser(newUser.user!, username, () {});
                nextPage(newUser.user);
              } else {
                throw "User is null";
              }
            } else {
              throw "User is null";
            }
            return 'Success';
          }
        } catch (e) {
          // Toast.show(e.toString(), duration: Toast.lengthLong);
          return e.toString();
        }
      }, 'username', username, context);
    } catch (e) {
      return e.toString();
    } finally {
      finalState();
    }
    return 'Error';
  }

  Future<String> loginUser(String password, String email,
      Function(UserCredential user) getUser, Function() finalState) async {
    try {
      final user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        getUser(user);
        return 'Success';
      } else {
        throw "user is null";
      }
    } catch (e) {
      return e.toString();
    } finally {
      finalState();
    }
  }

  Future<String> signOut(Function() finalState) async {
    try {
      auth.signOut();
      return 'Success';
    } catch (e) {
      return e.toString();
    } finally {
      finalState();
    }
  }
}
