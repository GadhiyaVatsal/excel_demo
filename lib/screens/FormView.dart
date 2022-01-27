import 'package:excel_demo/constant/constants.dart';
import 'package:excel_demo/controller/form_controller.dart';
import 'package:excel_demo/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormView extends GetView<FormController> {
  const FormView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // formController.onInit();
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore CRUD'),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                authController.signOut();
              },
              child: Text('Sign Out'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _buildAddEditEmployeeView(text: 'ADD', addEditFlag: 1, docId: '');
            },
          )
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.employees.length,
            itemBuilder: (context, index) => Card(
              color: const Color(0xffffffff),
              child: ListTile(
                title: Text(controller.employees[index].name!),
                subtitle: Text(controller.employees[index].address!),
                leading: CircleAvatar(
                  child: Text(
                    controller.employees[index].name!
                        .substring(0, 1)
                        .capitalize!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.yellow,
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    displayDeleteDialog(controller.employees[index].docId!);
                  },
                ),
                onTap: () {
                  controller.nameController.text =
                      controller.employees[index].name!;
                  controller.addressController.text =
                      controller.employees[index].address!;
                  _buildAddEditEmployeeView(
                      text: 'UPDATE',
                      addEditFlag: 2,
                      docId: controller.employees[index].docId!);
                },
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage())),
        child: Text(
          'Home',
        ),
      ),
    );
  }

  _buildAddEditEmployeeView({String? text, int? addEditFlag, String? docId}) {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
          color: Color(0xffffffff),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
          child: Form(
            key: controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${text} Employee',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.nameController,
                    validator: (value) {
                      return controller.validateName(value!);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.addressController,
                    validator: (value) {
                      return controller.validateAddress(value!);
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        width: Get.context!.width, height: 45),
                    child: ElevatedButton(
                      child: Text(
                        text!,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                      onPressed: () {
                        controller.saveUpdateEmployee(
                            controller.nameController.text,
                            controller.addressController.text,
                            docId!,
                            addEditFlag!);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  displayDeleteDialog(String docId) {
    Get.defaultDialog(
      title: "Delete Employee",
      titleStyle: TextStyle(fontSize: 20),
      middleText: 'Are you sure to delete employee ?',
      textCancel: "Cancel",
      textConfirm: "Confirm",
      confirmTextColor: Colors.black,
      onCancel: () {},
      onConfirm: () {
        controller.deleteData(docId);
      },
    );
  }
}
