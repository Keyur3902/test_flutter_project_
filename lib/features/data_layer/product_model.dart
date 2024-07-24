class ProductModel {
  final List<Product> getProductsResult;

  ProductModel({required this.getProductsResult});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      getProductsResult: (json['GetProductsResult'] as List)
          .map((i) => Product.fromJson(i))
          .toList(),
    );
  }
}

class Product {
  final String? barCode;

  // final DateTime createdDate;
  // final dynamic deleted;
  // final dynamic id;
  // final dynamic isSpecialOfferSelected;
  // final dynamic isWeight;
  // final DateTime modifiedDate;
  final String name;

  // final String nominalCode;
  // final dynamic packSize;
  final dynamic price;
  // final String productCategory;
  // final String productCode;
  // final dynamic productVatId;

  Product({
    required this.barCode,
    // required this.createdDate,
    // required this.deleted,
    // required this.id,
    // required this.isSpecialOfferSelected,
    // required this.isWeight,
    // required this.modifiedDate,
    required this.name,
    // required this.nominalCode,
    // required this.packSize,
    required this.price,
    // required this.productCategory,
    // required this.productCode,
    // required this.productVatId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      barCode: json['BarCode'] ?? '',
      // createdDate: DateTime.parse(_parseDate(json['CreatedDate'])),
      // deleted: json['Deleted'],
      // id: json['Id'],
      // isSpecialOfferSelected: json['IsSpecialOfferSelected'],
      // isWeight: json['IsWeight'],
      // modifiedDate: DateTime.parse(_parseDate(json['ModifiedDate'])),
      name: json['Name'],
      // nominalCode: json['NominalCode'],
      // packSize: json['PackSize'],
      price: (json['Price'] as num).toDouble(),
      // productCategory: json['ProductCategory'] ?? '',
      // productCode: json['ProductCode'] ?? '',
      // productVatId: json['ProductVatId'],
    );
  }

  static String _parseDate(String date) {
    final regex = RegExp(r'/Date\((\d+)\+?\d*\)/');
    final match = regex.firstMatch(date);
    if (match != null) {
      final timestamp = int.parse(match.group(1)!);
      return DateTime.fromMillisecondsSinceEpoch(timestamp).toIso8601String();
    }
    throw const FormatException('Invalid date format');
  }
}
