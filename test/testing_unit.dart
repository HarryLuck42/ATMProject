import 'package:atm_project/helper/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements User {}

final MockUser _mockUser = MockUser();

class MockAuth extends Mock implements FirebaseAuth {
  @override
  Stream<User?> authStateChanges() {
    return Stream.fromIterable([
      _mockUser,
    ]);
  }
}

void main() {
  final MockAuth mockAuth = MockAuth();
  final auth = Auth(auth: mockAuth);
  setUp(() {});
  tearDown(() {});

  test("login", () {
    expectLater(auth.user, emitsInOrder([_mockUser]));
  });

  // test("register user", () async {
  //   when(mockAuth.createUserWithEmailAndPassword(
  //           email: "melly@gmail.com", password: "123456"))
  //       .thenAnswer((realInvocation) async=> );
  //   expect(
  //       await auth.registerUser("Melly", "123456", "melly@gmail.com",
  //           (p0) => null, () => null, null),
  //       "Success");
  // });
}
