import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter_project/features/presentation/cubits/product_cubit/product_state.dart';
import '../../../../services/api_services.dart';
import '../../../../services/local_database_service/db_helper.dart';
import '../../../data_layer/product_model.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitialState()) {
    // fetchProducts();
  }

  List<Product> productDataLocal = [];
  String dropDownValue = "round 27cm";
  String selectP = "40.0";

  Future<void> fetchProducts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(ProductLoadingState());
    try {
      final response = await ApiService().dioApiCalling(
          method: RequestMethod.post,
          endPoints: "GetProducts",
          data: {
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
            },
            "syncDate": "/Date(536436000-600)/",
            "pageIndex": 0,
            "appVersionNo": "1.0",
            "deviceDate": "/Date(1720768210-600)/"
          });

      List<dynamic> customerData = response.data['GetProductsResult'];
      List<Map<String, dynamic>> formattedData =
          customerData.map((item) => Map<String, dynamic>.from(item)).toList();
      String sql = DBHelper.instance
          .multipleInsertRecordSQL(formattedData, "GetProductsResult");

      if (sql.isNotEmpty) {
        await DBHelper.instance.execute(sql);
      }


      emit(ProductSuccessState());
      prefs.setBool("IsAddedProduct", true);
    } catch (e) {
      print(e);
      print("error ProductCubit");
      emit(ProductFailState());
    }
  }

  Future<void> getProductDataFromLocal() async {
    emit(ProductLoadingState());
    try{
      List<Map<String, dynamic>> data =
      await DBHelper.instance.getData("GetProductsResult");
      Map<String, Product> productMap = {};

      for (int i = 0; i < data.length; i++) {
        Product product = Product.fromJson(data[i]);
        productMap[product.name] =
            product;
      }
      productDataLocal = productMap.values.toList();
      emit(ProductSuccessState());
    }
    catch(e){
      return;
    }
  }

  Future<void> selectProduct({required String value}) async {
    try{
      dropDownValue = value;
      emit(ProductSelectedState());
    }
    catch(e){
      return;
    }
  }


  Future<void> selectPrice({required String value}) async {
    try{
      selectP = value;
      emit(ProductSelectedState());
    }
    catch(e){
      return;
    }
  }
}
