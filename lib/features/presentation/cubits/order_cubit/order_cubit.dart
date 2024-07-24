import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../services/local_database_service/all_table.dart';
import '../../../../services/local_database_service/db_helper.dart';
import '../../../data_layer/order_model.dart';
import 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit()
      : super(OrderInitialState()) {
    getCartItemList();
  }

  // String name = "Tesco Ballymena";
  // String unitPrice = "0";
  // String totalPrice = "0";
  // String netPrice = "0";
  // TextEditingController quantity = TextEditingController();

  List<Order> orderTable = [];

  Future<void> insertCartData({required String name, required String quantity, required String unitPrice, required String totalPrice, required String netPrice}) async {
    emit(OrderLoadingState());
    try {
      Map<String, dynamic> insertData = {
        "name": name,
        "quantity": quantity,
        "unit_price": unitPrice,
        "total_price": totalPrice,
        "net_price": netPrice,
      };

      await DBHelper.instance.insertData(AllTable.tableCart, insertData);
      await getCartItemList();
      emit(OrderSuccessState());
    } catch (e) {
      emit(OrderFailState());
    }
  }


  Future<void> getCartItemList() async {
    try{
      orderTable.clear();
      emit(OrderLoadingState());
      var query =
          "SELECT * from ${AllTable.tableCart}";
      var data = await DBHelper.instance.getAllData(query);
      var parsedData = data.map((item) => Order.fromJson(item)).toList();
      orderTable.addAll(parsedData);
      emit(OrderSuccessState());
    }
    catch(e){
      print(e);
      return;
    }

  }
}
