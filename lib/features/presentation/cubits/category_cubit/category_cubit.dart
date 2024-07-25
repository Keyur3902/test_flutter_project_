import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../services/api_services.dart';
import '../../../../services/local_database_service/db_helper.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitialState()) {
    // fetchCategory();
  }

  List<String> categoryDataLocal = [];
  String dropDownValue = "breads";

  Future<void> fetchCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(CategoryLoadingState());
    try {
      final response = await ApiService().dioApiCalling(
          method: RequestMethod.post,
          endPoints: "GetCategories",
          data: {
            "appVersionNo": "20240715.14",
            "deviceDate": "/Date(1721035961915+0530)/",
            "user": {
              "Active": true,
              "AppType": "Mobile",
              "DeviceId": "7f2226495640ecb1",
              "FirstName": "Vinay",
              "Id": 3,
              "IsResetSync": false,
              "LastName": "Emu",
              "OrderCode": "VIE",
              "OrderCount": 98,
              "OrderPredictionCount": 19,
              "Password": "v",
              "Role": "Driver",
              "UserName": "v"
            }
          });
      List<dynamic> customerData = response.data['GetCategoriesResult'];
      List<Map<String, dynamic>> formattedData = customerData.map((item) {
        return {'Categories': item};
      }).toList();
      for (var item in formattedData) {
        int result =
            await DBHelper.instance.insertData("GetCategoriesResult", item);
        if (result == 0) {
          print("Failed to insert: $item");
        }
      }

      emit(CategorySuccessState());
      prefs.setBool("IsAddedCategory", true);
    } catch (e) {
      print(e);
      print("error CategoryCubit");
      emit(CategoryFailState());
    }
  }

  Future<void> selectCategory({required String value}) async {
    try{
      dropDownValue = value;
      emit(CategorySelectState());
    }
    catch(e){
      return;
    }
  }

  Future<void> getCategoryDataFromLocal() async {
    emit(CategoryLoadingState());
    try{
      List<Map<String, dynamic>> data =
      await DBHelper.instance.getData("GetCategoriesResult");
      Set<String> uniqueCategories = {};

      for (var item in data) {
        uniqueCategories.add(item['Categories'] as String);
      }
      categoryDataLocal = uniqueCategories.toList();
      emit(CategorySuccessState());
    }
    catch(e){
      return;
    }
  }
}
