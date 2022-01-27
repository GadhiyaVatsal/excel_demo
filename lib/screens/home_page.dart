import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:excel_demo/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  var excel = Excel.createExcel();
  late Sheet user;
  late Directory downloadDirectory;

  @override
  void initState() {
    user = excel['user'];
    getPath();
    super.initState();
  }

  getPath() async {
    downloadDirectory = await getApplicationDocumentsDirectory();
  }

  Future<void> createExcel() async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/test.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    print(file);
    OpenFile.open(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: users.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                var cell = user.cell(CellIndex.indexByString("A${i + 1}"));
                Map<String, dynamic> data =
                    snapshot.data!.docs[i].data()! as Map<String, dynamic>;
                print(data['name']);
                cell.value = data['name'];
                print(cell.value);
              }
              print(excel);
              /*snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                var cell = user.cell(CellIndex.indexByString("Name"));
                cell.value = data['name'];
              }).toList();*/
              var fileBytes = excel.save();
              // var path = getPath();
              /*File('$downloadDirectory/excel.xlsx')
                ..createSync()
                ..writeAsBytesSync(fileBytes!);*/

              print('Path of New Dir: ' + downloadDirectory.path);
              String fileName = '${downloadDirectory.path}/demo.xlsx';
              File(fileName)
                ..createSync(recursive: true)
                ..writeAsBytesSync(fileBytes!)
                ..open(mode: FileMode.read);
              OpenFile.open(fileName);

              return Column(
                children: [
                  ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                        title: Text(data['name']),
                        subtitle: Text(data['number']),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      authController.signOut();
                    },
                    child: Text('SignOut'),
                  ),
                  ElevatedButton(
                    onPressed: createExcel,
                    child: Text('Create Excel'),
                  ),
                ],
              );
            } else {
              return ElevatedButton(
                onPressed: () {
                  authController.signOut();
                },
                child: Text('SignOut'),
              );
            }
          }),
    );
  }
}
