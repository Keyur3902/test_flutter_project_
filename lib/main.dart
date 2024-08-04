import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_project/features/presentation/cubits/order_cubit/order_cubit.dart';
import 'package:test_flutter_project/routes/app_routes.dart';
import 'package:test_flutter_project/services/local_database_service/db_helper.dart';
import 'features/presentation/cubits/category_cubit/category_cubit.dart';
import 'features/presentation/cubits/customer_cubit/customer_cubit.dart';
import 'features/presentation/cubits/product_cubit/product_cubit.dart';
import 'features/presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DBHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  static String getInitialRoute() {
    return HomeScreen.routeName;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoryCubit>(
          create: (_) => CategoryCubit(),
        ),
        BlocProvider<CustomerCubit>(
          create: (_) => CustomerCubit(),
        ),
        BlocProvider<ProductCubit>(
          create: (_) => ProductCubit(),
        ),
        BlocProvider<OrderCubit>(
          create: (_) => OrderCubit(),
        ),
      ],
      child: MaterialApp(
        initialRoute: getInitialRoute(),
        routes: AppRoutes.getAppRoutes,
      ),
    );
  }
}
