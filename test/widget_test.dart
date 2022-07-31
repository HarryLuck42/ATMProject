// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:atm_project/app.dart';
import 'package:atm_project/helper/auth.dart';
import 'package:atm_project/register/register_screen.dart';
import 'package:atm_project/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:atm_project/main.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class MockRepository extends Mock implements Auth {
  final MockAuth mockAuth;
  MockRepository({required this.mockAuth});
}

class MockAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final _auth = MockAuth();
  final user = BehaviorSubject<MockUser>();
  final _repo = MockRepository(mockAuth: _auth);
  Widget _makeTestable(Widget child) {
    return ChangeNotifierProvider<Auth>.value(
      value: _repo,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  //regis
  final usernameRegis = find.byKey(App.keyUsernameRegis);
  final emailRegis = find.byKey(App.keyEmailRegis);
  final passwordRegis = find.byKey(App.keyPasswordRegis);
  final buttonRegis = find.byKey(App.keyRegisButton);
  //login
  final emailLogin = find.byKey(App.keyEmailLogin);
  final passwordLogin = find.byKey(App.keyPasswordLogin);
  final buttonLogin = find.byKey(App.keyLoginButton);

  group("group regis test", () {
    testWidgets('Create Users', (WidgetTester tester) async {
      // Populate the fake database.
      await tester.idle();
      await tester.pump();
      await tester.pumpWidget(_makeTestable(RegisterScreen()));
      expect(usernameRegis, findsOneWidget);
      expect(emailRegis, findsOneWidget);
      expect(passwordRegis, findsOneWidget);
      expect(buttonRegis, findsOneWidget);
      // await tester.idle();
      // await tester.pump();
      // // await tester.tap(find.byKey(App.keyUsernameRegis));
      // await tester.pump(Duration(milliseconds: 400));
      // await tester.enterText(usernameRegis, 'Jack');
      // await tester.pump(Duration(milliseconds: 400));
      // await tester.enterText(emailRegis, 'jack@email.com');
      // await tester.pump(Duration(milliseconds: 400));
      // await tester.enterText(passwordRegis, '123456');
      // await tester.pump(Duration(milliseconds: 400));
      // await tester.tap(find.byKey(App.keyRegisButton));
      // await tester.idle();
      // await tester.pump(Duration(seconds: 2));
      // expect(find.text('Email: jack@email.com'), findsOneWidget);
    });
  });
}
