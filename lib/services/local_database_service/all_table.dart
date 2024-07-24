import 'package:sqflite/sqflite.dart';
import 'db_helper.dart';

class AllTable {
  static var tableProduct = "GetProductsResult";
  static var tableCategory = "GetCategoriesResult";
  static var tableCustomer = "GetCustomersResult";
  static var tableCart = "GetCartResult";

  final Database db;
  final int version;

  AllTable(this.db, this.version);

  Future<void> createAllTable() async {
    await DBHelper.instance.createTableData(db, tableCustomer, [
      'AccountRef TEXT',
      'Address1 TEXT',
      'Address2 TEXT',
      'Address3 TEXT',
      'Address4 TEXT',
      'Address5 TEXT',
      'CAddress1 TEXT',
      'CAddress2 TEXT',
      'CAddress3 TEXT',
      'CAddress4 TEXT',
      'CAddress5 TEXT',
      'ContactName TEXT',
      'CountryCode TEXT',
      'CreatedDate DATETIME',
      'DateAccountOpened DATETIME',
      'DiscountPercentage FLOAT',
      'Email TEXT',
      'Fax TEXT',
      'IsCostcutter NUMBER(1)',
      'IsDeleted NUMBER(1)',
      'IsHenderson NUMBER(1)',
      'IsMessageEnabled NUMBER(1)',
      'IsMusgrave NUMBER(1)',
      'IsPredictionEnable NUMBER(1)',
      'IsTemplateEnable NUMBER(1)',
      'Message TEXT',
      'ModifiedDate TEXT',
      'Name TEXT',
      'Telephone TEXT',
      'Telephone2 DATETIME',
      'WebAddress TEXT',
    ]);

    await DBHelper.instance.createTableData(db, tableCategory, [
      'Categories TEXT',
    ]);

    await DBHelper.instance.createTableData(db, tableProduct, [
      'BarCode TEXT',
      'CreatedDate DATETIME',
      'Deleted NUMBER(1)',
      'Id INTEGER',
      'IsSpecialOfferSelected NUMBER(1)',
      'IsWeight NUMBER(1)',
      'ModifiedDate DATETIME',
      'Name TEXT',
      'NominalCode TEXT',
      'PackSize INTEGER',
      'Price FLOAT',
      'ProductCategory TEXT',
      'ProductCode TEXT',
      'ProductVatId INTEGER'
    ]);

    await DBHelper.instance.createTableData(db, tableCart, [
      'id INTEGER PRIMARY KEY',
      'name TEXT',
      'quantity TEXT',
      'unit_price TEXT',
      'total_price TEXT',
      'net_price TEXT',
    ]);
  }
}
