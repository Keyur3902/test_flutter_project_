import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/api_services.dart';
import '../../../../services/local_database_service/db_helper.dart';
import '../../../data_layer/customer_model.dart';
import 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerInitialState()) {
    // fetchCustomers();
  }

  List<Customer> customerDataLocal = [];
  String dropDownValue = "Tesco Ballymena";

  Future<void> fetchCustomers() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(CustomerLoadingState());
    try {
      customerDataLocal.clear();
      emit(CustomerLoadingState());
      final response = await ApiService().dioApiCalling(
          method: RequestMethod.post,
          endPoints: "GetCustomers",
          data: {
            "user": {
              "UserName": "v",
              "Password": "v",
              "DeviceId": "355622080315528",
              "Active": true,
              "AppType": "Android",
              "FirstName": "Vinay",
              "Id": 3,
              "LastName": "Patel",
              "OrderCode": "VIE",
              "OrderCount": 1,
              "OrderPredictionCount": 1,
              "Role": "Driver"
            },
            "syncDate": "/Date(536436000-600)/",
            "pageIndex": 0,
            "appVersionNo": "1.0",
            "deviceDate": "/Date(536436000-600)/"
          });
      List<dynamic> customerData = response.data['GetCustomersResult'];
      List<Map<String, dynamic>> formattedData =
          customerData.map((item) => Map<String, dynamic>.from(item)).toList();
      String sql = DBHelper.instance
          .multipleInsertRecordSQL(formattedData, "GetCustomersResult");

      if (sql.isNotEmpty) {
        await DBHelper.instance.execute(sql);
      }
      // List<Map<String, dynamic>> data =
      //     await DBHelper.instance.getData("GetCustomersResult");
      // for (int i = 0; i < data.length; i++) {
      //   customerDataLocal.add(Customer.fromJson(data[i]));
      // }
      emit(CustomerSuccessState());
      prefs.setBool("IsAddedCustomer", true);
    } catch (e) {
      emit(CustomerFailState());
      print(e);
      print("error CustomerCubit");
    }
  }

  Future<void> selectProduct({required String value}) async {
    try{
      dropDownValue = value;
      emit(CustomerSelectState());
    }
    catch(e){
      return;
    }
  }

  Future<void> getCustomerDataFromLocal () async {
    emit(CustomerLoadingState());
    try{
      List<Map<String, dynamic>> data =
      await DBHelper.instance.getData("GetCustomersResult");
      Map<String, Customer> customerMap = {};

      for (int i = 0; i < data.length; i++) {
        Customer customer = Customer.fromJson(data[i]);
        customerMap[customer.accountRef] =
            customer; // This will replace existing entries with the same accountRef
      }
      customerDataLocal = customerMap.values.toList();
      emit(CustomerSuccessState());
    }
    catch(e){
      return;
    }
  }
}
