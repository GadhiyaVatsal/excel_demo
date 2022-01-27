import 'package:excel_demo/constant/constants.dart';
import 'package:excel_demo/screens/FormView.dart';
import 'package:excel_demo/screens/Logout.dart';
import 'package:excel_demo/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController authController = Get.find();
  late Rx<User?> firebaseUser;
  RxString userId = ''.obs;

  @override
  void onReady() {
    super.onReady();

    firebaseUser = Rx<User?>(auth.currentUser);

    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      userId.value = user.uid;
      // Get.offAll(() => const FormView());
      Get.offAll(() => const Logout());
    }
  }

  void login(String email, String pass) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: pass);

      userId.value = auth.currentUser!.uid;
      return Get.offAll(() => const Logout());
    } on FirebaseException catch (e) {
      if (e.code == "wrong-password") {
        Get.snackbar(
          "Wrong Password",
          "Password incorrect",
        );
      } else if (e.code == "user-not-found") {
        Get.snackbar(
          "User Not Exist",
          "Please create account",
        );
      }
    } catch (e) {
      print(e);
    } finally {
      //ApplicationUtils.closeDialog();
    }
  }

  void signOut() async {
    await auth.signOut();
  }
}
