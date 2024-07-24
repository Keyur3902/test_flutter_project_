class CustomerModel {
  final List<Customer> getCustomersResult;

  CustomerModel({required this.getCustomersResult});

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      getCustomersResult: (json['GetCustomersResult'] as List)
          .map((i) => Customer.fromJson(i))
          .toList(),
    );
  }
}

class Customer {
  final String accountRef;

  final String address1;
  final String address2;
  final String address3;
  final String? address4;
  final String? address5;
  final String cAddress1;
  final String cAddress2;
  final String? cAddress3;
  final String? cAddress4;
  final String? cAddress5;
  final String contactName;
  final String countryCode;
  final DateTime createdDate;
  final DateTime dateAccountOpened;
  final double discountPercentage;
  final String email;
  final dynamic fax;
  final dynamic isCostcutter;

  final dynamic isDeleted;
  final dynamic isHenderson;
  final dynamic isMessageEnabled;
  final dynamic isMusgrave;
  final dynamic isPredictionEnable;
  final dynamic isTemplateEnable;
  final String message;
  final DateTime modifiedDate;
  final String name;
  final String telephone;
  final String? telephone2;
  final String? webAddress;

  Customer({
    required this.accountRef,
    required this.address1,
    required this.address2,
    required this.address3,
    this.address4,
    this.address5,
    required this.cAddress1,
    required this.cAddress2,
    this.cAddress3,
    this.cAddress4,
    this.cAddress5,
    required this.contactName,
    required this.countryCode,
    required this.createdDate,
    required this.dateAccountOpened,
    required this.discountPercentage,
    required this.email,
    this.fax,
    required this.isCostcutter,
    required this.isDeleted,
    required this.isHenderson,
    required this.isMessageEnabled,
    required this.isMusgrave,
    required this.isPredictionEnable,
    required this.isTemplateEnable,
    required this.message,
    required this.modifiedDate,
    required this.name,
    required this.telephone,
    this.telephone2,
    this.webAddress,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      accountRef: json['AccountRef'],
      address1: json['Address1'] ?? '',
      address2: json['Address2'] ?? '',
      address3: json['Address3'] ?? '',
      address4: json['Address4'] ?? '',
      address5: json['Address5'] ?? '',
      cAddress1: json['CAddress1'] ?? '',
      cAddress2: json['CAddress2'] ?? '',
      cAddress3: json['CAddress3'] ?? '',
      cAddress4: json['CAddress4'] ?? '',
      cAddress5: json['CAddress5'] ?? '',
      contactName: json['ContactName'] ?? '',
      countryCode: json['CountryCode'] ?? '',
      createdDate: DateTime.parse(_parseDate(json['CreatedDate'])),
      dateAccountOpened: DateTime.parse(_parseDate(json['DateAccountOpened'])),
      discountPercentage: (json['DiscountPercentage'] as num).toDouble(),
      email: json['Email'] ?? '',
      fax: json['Fax'],
      isCostcutter: json['IsCostcutter'],
      isDeleted: json['IsDeleted'],
      isHenderson: json['IsHenderson'],
      isMessageEnabled: json['IsMessageEnabled'],
      isMusgrave: json['IsMusgrave'],
      isPredictionEnable: json['IsPredictionEnable'],
      isTemplateEnable: json['IsTemplateEnable'],
      message: json['Message'] ?? '',
      modifiedDate: DateTime.parse(_parseDate(json['ModifiedDate'])),
      name: json['Name'] ?? '',
      telephone: json['Telephone'] ?? '',
      telephone2: json['Telephone2'] ?? '',
      webAddress: json['WebAddress'] ?? '',
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
