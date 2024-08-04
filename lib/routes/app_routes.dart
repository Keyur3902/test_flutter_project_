import 'package:flutter/cupertino.dart';
import 'package:test_flutter_project/features/presentation/screens/home_screen.dart';
import 'package:test_flutter_project/features/presentation/screens/order_details_sceen.dart';

class AppRoutes {
  static Map<String, Widget Function(BuildContext)> get getAppRoutes =>
      {
        HomeScreen.routeName: (_) =>
        const HomeScreen(),
        
        OrderDetailsScreen.routeName: (_) {
          final args = ModalRoute.of(_)!.settings.arguments
          as Map<String, dynamic>;
          return OrderDetailsScreen(orderTable: args['orderTable'], signature: args['signature'],);
        }
      };
}
