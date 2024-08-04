import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../data_layer/order_model.dart';

class OrderDetailsScreen extends StatelessWidget {
  final List<Order> orderTable;
  final Uint8List? signature;
  const OrderDetailsScreen(
      {super.key, required, required this.orderTable, this.signature});

  static const routeName = '/orderDetailsScreen';

  int calculateTotalQuantity() {
    return orderTable.fold(0, (sum, order) => sum + int.parse(order.quantity));
  }

  double calculateTotalUnitPrice() {
    return orderTable.fold(
        0, (sum, order) => sum + double.parse(order.unitPrice));
  }

  double calculateTotalAllPrice() {
    return orderTable.fold(
        0, (sum, order) => sum + double.parse(order.totalPrice));
  }

  double calculateTotalNetPrice() {
    return orderTable.fold(
        0, (sum, order) => sum + double.parse(order.netPrice));
  }

  @override
  Widget build(BuildContext context) {
    final String totalQuantity = calculateTotalQuantity().toString();
    final String totalUnitPrice = calculateTotalUnitPrice().toString();
    final String totalAllPrice = calculateTotalAllPrice().toString();
    final String totalNetPrice = calculateTotalNetPrice().toString();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black38,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text("Name"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black38,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text("Qty"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black38,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text("Unit Price"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black38,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text("Total Price"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black38,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text("Net Price (%)"),
                      ),
                    ),
                  ),
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: orderTable.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                            child: Text(orderTable[index].name),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                            child: Text(orderTable[index].quantity),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                            child: Text(orderTable[index].unitPrice),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                            child: Text(orderTable[index].totalPrice),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.black),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                            child: Text(orderTable[index].netPrice),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black12,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text("Total"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text(totalQuantity),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text(totalUnitPrice),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text(totalAllPrice),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.black12,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                        child: Text(totalNetPrice),
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: signature == null
                    ? const Text("Please add signature")
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Signature",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),),
                        Image.memory(signature!,
                        width: 200),
                      ],
                    ),
              ),
            ],
          ),
        ));
  }
}
