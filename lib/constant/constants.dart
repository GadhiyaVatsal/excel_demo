import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel_demo/controller/form_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../controller/auth_contorller.dart';

AuthController authController = AuthController.authController;
FormController formController = FormController.formController;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
