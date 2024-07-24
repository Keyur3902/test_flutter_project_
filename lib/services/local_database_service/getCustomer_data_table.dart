// import 'dart:convert';
// import 'package:sqflite/sqflite.dart';
// import '../../features/data_layer/customer_model.dart';
// import 'db_helper.dart';
//
// class GetCustomerDataTable {
//   static const String _tableName = "customer_data_table";
//
//   static const createCustomerTable = """
//   CREATE TABLE IF NOT EXISTS $_tableName(value TEXT)
//   """;
//
//   static Future<void> addCustomerData(
//       {required Map<String, dynamic> dataValue}) async {
//     try {
//       Database db = await DBHelper.getDataBaseInstance();
//       await db.insert(_tableName, {"value": dataValue.toString()});
//       return;
//     } catch (e) {
//       return;
//     }
//   }
//
//   static Future<List<CustomerModel>> getCustomerData() async {
//     try {
//       Database db = await DBHelper.getDataBaseInstance();
//       final data = await db.query(_tableName);
//       List<CustomerModel> customers = data.map((item) {
//         Map<String, dynamic> jsonData = jsonDecode(item['value'] as String);
//         return CustomerModel.fromJson(jsonData);
//       }).toList();
//
//       return customers;
//     } catch (e) {
//       print("Data error");
//       print(e);
//       return [];
//     }
//   }
// }
