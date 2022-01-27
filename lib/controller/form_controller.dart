import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel_demo/constant/constants.dart';
import 'package:excel_demo/model/employeeModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  static FormController formController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController nameController, addressController;

  late CollectionReference collectionReference;

  RxList<EmployeeModel> employees = RxList<EmployeeModel>([]);

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
    addressController = TextEditingController();
      collectionReference = firestore
          .collection("A")
          .doc("${auth.currentUser!.uid}")
          .collection("sg_panel")
          .doc("${auth.currentUser!.uid}")
          .collection("cad");
      employees.bindStream(getAllEmployees());

  }

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name can not be empty";
    }
    return null;
  }

  String? validateAddress(String value) {
    if (value.isEmpty) {
      return "Address can not be empty";
    }
    return null;
  }

  void saveUpdateEmployee(
      String name, String address, String docId, int addEditFlag) {
    final isValid = formKey.currentState?.validate();
    if (!isValid!) {
      return;
    }
    formKey.currentState!.save();
    if (addEditFlag == 1) {
      collectionReference
          .add({'name': name, 'address': address}).whenComplete(() {
        clearEditingControllers();
        Get.snackbar(
          "Employee Added",
          "Employee added successfully",
        );
      });
    } else if (addEditFlag == 2) {
      collectionReference
          .doc(docId)
          .update({'name': name, 'address': address}).whenComplete(() {
        clearEditingControllers();
      });
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
  }

  void clearEditingControllers() {
    nameController.clear();
    addressController.clear();
  }

  Stream<List<EmployeeModel>> getAllEmployees() =>
      collectionReference.snapshots().map((query) =>
          query.docs.map((item) => EmployeeModel.fromMap(item)).toList());

  void deleteData(String docId) {
    collectionReference.doc(docId).delete().whenComplete(() {
      Get.back();
    }).catchError((error) {});
  }
}
