import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel_demo/constant/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class SgStocks extends StatefulWidget {
  const SgStocks({Key? key}) : super(key: key);

  @override
  _SgStocksState createState() => _SgStocksState();
}

class _SgStocksState extends State<SgStocks> {
  TextEditingController panelController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  CollectionReference reference = firestore.collection("A")
      .doc(auth.currentUser!.uid)
      .collection("sg_panel")
      .doc("stocks_id").collection('sg_stocks');
  bool isProcessing = false;

  _storeStocks() async{
    setState(() {
      isProcessing = true;
    });
    var stockVal = 0;
    /*await reference.orderBy("bn_number", descending: true).limit(1).get().then((value) {
      print(value.docs.first.data());
      stockVal = int.parse(value.docs.first.id);
    });*/

    await firestore.collection("A")
        .doc(auth.currentUser!.uid)
        .collection("sg_panel")
        .doc("stocks_id").get().then((value) {
          if(value.exists) {
            stockVal = value.get('unique_id');
          }else {
            stockVal = 0;
          }
    });

    for(int i=1; i<=int.parse(quantityController.text); i++){
      stockVal++;
      reference.doc("$stockVal").set({'name': panelController.text, 'bn_number': stockVal});
    }
    print("Unique Id: $stockVal");
    await firestore.collection("A")
        .doc(auth.currentUser!.uid)
        .collection("sg_panel")
        .doc("stocks_id").set({'unique_id': stockVal});

    setState(() {
      isProcessing = false;
    });
    panelController.clear();
    quantityController.clear();
    Get.snackbar(
      "Stock Added",
      "Stock added successfully",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: panelController,
              decoration: InputDecoration(
                label: const Text('Panel'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
              ),
            ),
            const SizedBox(height: 20,),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  label: const Text('Quantity'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
              ),
            ),
            const SizedBox(height: 20,),
            isProcessing ? const CircularProgressIndicator() : ElevatedButton(onPressed: _storeStocks, child: const Text('Add')),
          ],
        ),
      ),
    );
  }
}
