// class CategoryModel {
//   final bool active;
//   final String appType;
//   final String deviceId;
//   final String firstName;
//   final int id;
//   final bool isResetSync;
//   final String lastName;
//   final String orderCode;
//   final int orderCount;
//   final int orderPredictionCount;
//   final String password;
//   final String role;
//   final String userName;
//
//   CategoryModel({
//     required this.active,
//     required this.appType,
//     required this.deviceId,
//     required this.firstName,
//     required this.id,
//     required this.isResetSync,
//     required this.lastName,
//     required this.orderCode,
//     required this.orderCount,
//     required this.orderPredictionCount,
//     required this.password,
//     required this.role,
//     required this.userName,
//   });
//
//   factory CategoryModel.fromJson(Map<String, dynamic> json) {
//     return CategoryModel(
//       active: json['Active'],
//       appType: json['AppType'],
//       deviceId: json['DeviceId'],
//       firstName: json['FirstName'],
//       id: json['Id'],
//       isResetSync: json['IsResetSync'],
//       lastName: json['LastName'],
//       orderCode: json['OrderCode'],
//       orderCount: json['OrderCount'],
//       orderPredictionCount: json['OrderPredictionCount'],
//       password: json['Password'],
//       role: json['Role'],
//       userName: json['UserName'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'Active': active,
//       'AppType': appType,
//       'DeviceId': deviceId,
//       'FirstName': firstName,
//       'Id': id,
//       'IsResetSync': isResetSync,
//       'LastName': lastName,
//       'OrderCode': orderCode,
//       'OrderCount': orderCount,
//       'OrderPredictionCount': orderPredictionCount,
//       'Password': password,
//       'Role': role,
//       'UserName': userName,
//     };
//   }
// }
//
// class SyncData {
//   final String appVersionNo;
//   final String deviceDate;
//   final CategoryModel user;
//
//   SyncData({
//     required this.appVersionNo,
//     required this.deviceDate,
//     required this.user,
//   });
//
//   factory SyncData.fromJson(Map<String, dynamic> json) {
//     return SyncData(
//       appVersionNo: json['appVersionNo'],
//       deviceDate: json['deviceDate'],
//       user: CategoryModel.fromJson(json['user']),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'appVersionNo': appVersionNo,
//       'deviceDate': deviceDate,
//       'user': user.toJson(),
//     };
//   }
// }

class CategoryModel {
  final List<String> getCategoriesResult;

  CategoryModel({required this.getCategoriesResult});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      getCategoriesResult: List<String>.from(json['GetCategoriesResult']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GetCategoriesResult': getCategoriesResult,
    };
  }
}
