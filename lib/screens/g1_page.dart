import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel_demo/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Column, Alignment, Row;

class G1Panel extends StatefulWidget {
  const G1Panel({Key? key}) : super(key: key);

  @override
  _G1PanelState createState() => _G1PanelState();
}

class _G1PanelState extends State<G1Panel> {
  var curr = "";
  var next = "";
  bool isEmpty = false;

  CollectionReference stockRef = firestore
      .collection("A")
      .doc(auth.currentUser!.uid)
      .collection("sg_panel")
      .doc("stocks_id")
      .collection('sg_stocks');

  CollectionReference g1ref = firestore
      .collection("A")
      .doc(auth.currentUser!.uid)
      .collection("sg_panel")
      .doc("g1_id")
      .collection('g1_panel');

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    var querySnapshot = await g1ref.get();
    if (querySnapshot.docs.isNotEmpty) {
      print("not empty");
      await g1ref
          .orderBy('next', descending: true)
          .limit(1)
          .get()
          .then((value) {
        setState(() {
          print(value.docs.first.get('current'));
          curr = value.docs.first.get('current').toString();
          next = value.docs.first.get('next').toString();
        });
      });
    } else {
      print("empty");
      setState(() {
        isEmpty = true;
      });
      _changeBottles();
    }
  }

  _changeBottles() async {
    await stockRef
        .where('name', isEqualTo: 'G1')
        .orderBy("bn_number")
        .get()
        .then((data) {
      if (isEmpty) {
        print(data.docs[0]['bn_number']);
        curr = data.docs[0]['bn_number'].toString();
        next = data.docs[1]['bn_number'].toString();
        // stockRef.doc(curr).delete();
        // stockRef.doc(next).delete();
      } else {
        if (!mounted) return;
        setState(() {
          curr = next;
          next = data.docs[0]['bn_number'].toString();
        });
      }
    });

    if (isEmpty) {
      stockRef.doc(curr).delete();
      stockRef.doc(next).delete();
      setState(() {
        isEmpty = false;
      });
    } else {
      stockRef.doc(next).delete();
    }
  }

  Future<void> createExcel() async {
    final Workbook workbook = Workbook();
    final Worksheet sheet1 = workbook.worksheets[0];
    sheet1.name = 'G1';

    sheet1.getRangeByName('A1').setText('Current');
    sheet1.getRangeByName('B1').setText('Next');

    await stockRef
        .where('name', isEqualTo: 'G1')
        .orderBy('bn_number')
        .get()
        .then((value) {
      print(value.docs.length);
      for (int i = 1; i < value.docs.length; i++) {
        sheet1
            .getRangeByName('A${i+1}')
            .setText(value.docs[i - 1]['bn_number'].toString());
        sheet1
            .getRangeByName('B${i+1}')
            .setText(value.docs[i]['bn_number'].toString());
      }
    });
    final List<int> bytes = workbook.saveAsStream();

    workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String fileName = '$path/excel.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);
    print(file);
    OpenFile.open(fileName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Current"),
              const SizedBox(height: 10),
              Text(curr),
              const SizedBox(height: 20),
              const Text("Next"),
              const SizedBox(height: 10),
              Text(next),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: _changeBottles,
                child: const Text('Done'),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: createExcel,
                child: const Text('Excel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
