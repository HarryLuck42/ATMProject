// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.


import 'package:atm_project/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:atm_project/main.dart';

void main() {
  group("Test Login", () async{
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final auth = FirebaseAuth.instance;
    Utils.registerUser('Haryy', '123456', 'harry@email.com', () => null, () => null, null);
    test("Login Test", (){
      expect(auth.currentUser, isNotNull);
    });
  });
}
