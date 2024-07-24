import 'package:flutter/material.dart';

class ProductButtonsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            // Add product to order
          },
          child: Text('Add Product'),
        ),
        ElevatedButton(
          onPressed: () {
            // Subtract product from order
          },
          child: Text('Subtract Product'),
        ),
        ElevatedButton(
          onPressed: () {
            // Delete product from order
          },
          child: Text('Delete Product'),
        ),
      ],
    );
  }
}
