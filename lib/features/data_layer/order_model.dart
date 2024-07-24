class Order {
  final String id;
  final String name;
  final String quantity;
  final String unitPrice;
  final String totalPrice;
  final String netPrice;

  Order({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.netPrice,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'].toString() ?? '',
      name: json['name'].toString() ?? '',
      quantity: json['quantity'].toString(),
        unitPrice: json['unit_price'].toString(),
        totalPrice: json['total_price'].toString(),
      netPrice: json['net_price'].toString(),
    );
  }


}