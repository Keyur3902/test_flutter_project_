import 'package:flutter/material.dart';

class OrderListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5, // This should be replaced with the actual order list length
      itemBuilder: (context, index) {
        return ListTile(
          title: Text('Product $index'),
          subtitle: Text('Quantity: 1'), // Replace with actual quantity
        );
      },
    );
  }
}
