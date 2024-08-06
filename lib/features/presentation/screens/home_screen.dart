import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:test_flutter_project/features/presentation/cubits/order_cubit/order_state.dart';
import 'package:test_flutter_project/features/presentation/screens/order_details_sceen.dart';
import '../../data_layer/customer_model.dart';
import '../../data_layer/product_model.dart';
import '../cubits/category_cubit/category_cubit.dart';
import '../cubits/category_cubit/category_state.dart';
import '../cubits/customer_cubit/customer_cubit.dart';
import '../cubits/customer_cubit/customer_state.dart';
import '../cubits/order_cubit/order_cubit.dart';
import '../cubits/product_cubit/product_cubit.dart';
import '../cubits/product_cubit/product_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  static const routeName = '/homeScreen';
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController quantity = TextEditingController();

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    getAll();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getAll() async {
    await fetchAllData();
    BlocProvider.of<OrderCubit>(context).getCartItemList();
    BlocProvider.of<CustomerCubit>(context).getCustomerDataFromLocal();
    BlocProvider.of<CategoryCubit>(context).getCategoryDataFromLocal();
    BlocProvider.of<ProductCubit>(context).getProductDataFromLocal();
  }

  Future<void> saveSignature() async {
    PermissionStatus storagePermissionStatus = await Permission.storage.status;

    if (!storagePermissionStatus.isGranted) {
      storagePermissionStatus = await Permission.storage.request();
    }
    if (storagePermissionStatus.isPermanentlyDenied) {
      openAppSettings();
    }
    if (_controller.isNotEmpty) {
      final signature = await _controller.toPngBytes();
      if (signature != null) {
        final Directory tempDir = await getApplicationSupportDirectory();
        final file = File(tempDir.path);
        await file.writeAsBytes(signature);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signature saved successfully!')),
        );
      }
    }
  }

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snackbarPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data =
        await _controller.toPngBytes(height: 1000, width: 1000);
    if (data == null) {
      return;
    }

    if (!mounted) return;

    await Navigator.pushNamed(context, OrderDetailsScreen.routeName,
        arguments: {
          'orderTable': BlocProvider.of<OrderCubit>(context).orderTable,
          'signature': data
        });
  }

  Future<void> fetchAllData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isAddedCustomer = prefs.getBool("IsAddedCustomer");
    bool? isAddedCategory = prefs.getBool("IsAddedCategory");
    bool? isAddedProduct = prefs.getBool("IsAddedProduct");
    isAddedCustomer == true
        ? null
        : await BlocProvider.of<CustomerCubit>(context).fetchCustomers();
    isAddedCategory == true
        ? null
        : await BlocProvider.of<CategoryCubit>(context).fetchCategory();
    isAddedProduct == true
        ? null
        : await BlocProvider.of<ProductCubit>(context).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text('Add Order'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        actions: [
          IconButton(
              onPressed: () async {
                await BlocProvider.of<OrderCubit>(context).getCartItemList();
                await BlocProvider.of<CustomerCubit>(context).fetchCustomers();
                await BlocProvider.of<CategoryCubit>(context).fetchCategory();
                await BlocProvider.of<ProductCubit>(context).fetchProducts();
                await getAll();
              },
              icon: const Icon(
                Icons.replay_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OrderCubit, OrderState>(builder: (_, orderState) {
          return BlocBuilder<CategoryCubit, CategoryState>(
              builder: (_, categoryState) {
            return BlocBuilder<ProductCubit, ProductState>(
                builder: (_, productState) {
              return BlocBuilder<CustomerCubit, CustomerState>(
                  builder: (_, customerState) {
                if (productState is ProductLoadingState ||
                    customerState is CustomerLoadingState ||
                    categoryState is CategoryLoadingState ||
                    orderState is OrderLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Total Units :${BlocProvider.of<OrderCubit>(context).orderTable.length}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700,
                                    fontSize: 18),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Select Customer",
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 18),
                              ),
                              dropDownWidgetCustomer(
                                customerList:
                                    BlocProvider.of<CustomerCubit>(context)
                                        .customerDataLocal,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Select Category",
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 18),
                              ),
                              dropDownWidgetCategory(
                                categoryList:
                                    BlocProvider.of<CategoryCubit>(context)
                                        .categoryDataLocal,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Select Product",
                                style: TextStyle(
                                    color: Colors.grey.shade700, fontSize: 18),
                              ),
                              dropDownWidgetProduct(
                                productList:
                                    BlocProvider.of<ProductCubit>(context)
                                        .productDataLocal,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              addItemWidget(),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black),
                                        color: Colors.black38,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.0, top: 5.0),
                                        child: Text("Name"),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1, color: Colors.black),
                                        color: Colors.black38,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.0, top: 5.0),
                                        child: Text("Qty"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      OrderDetailsScreen.routeName,
                                      arguments: {
                                        'orderTable':
                                            BlocProvider.of<OrderCubit>(context)
                                                .orderTable
                                      });
                                },
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount:
                                      BlocProvider.of<OrderCubit>(context)
                                          .orderTable
                                          .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, top: 5.0),
                                              child: Text(
                                                  BlocProvider.of<OrderCubit>(
                                                          context)
                                                      .orderTable[index]
                                                      .name),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.black),
                                              color: Colors.white,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0, top: 5.0),
                                              child: Text(
                                                  BlocProvider.of<OrderCubit>(
                                                          context)
                                                      .orderTable[index]
                                                      .quantity),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        "Signature",
                        style: TextStyle(
                            color: Colors.grey.shade700, fontSize: 18),
                      ),
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black),
                        ),
                        child: Signature(
                          controller: _controller,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () {
                              _controller.clear();
                            },
                            child: const Text(
                              "Clear Signature",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              // saveSignature();
                              exportImage(context);
                            },
                            child: const Text(
                              "Save Signature",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              });
            });
          });
        }),
      ),
    );
  }

  Widget dropDownWidgetCustomer({
    required List<Customer> customerList,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.black,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: customerList.map((Customer customer) {
          return DropdownMenuItem<String>(
            value: customer.name,
            child: Text(customer.name),
          );
        }).toList(),
        value: BlocProvider.of<CustomerCubit>(context).dropDownValue,
        onChanged: (String? newValue) {
          BlocProvider.of<CustomerCubit>(context)
              .selectProduct(value: newValue!);
        },
        style: const TextStyle(color: Colors.black),
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        dropdownColor: Colors.white,
      ),
    );
  }

  // Function to get price based on product name
  double getPriceByName(String name) {
    for (var product
        in BlocProvider.of<ProductCubit>(context).productDataLocal) {
      if (product.name == name) {
        return product.price;
      }
    }
    throw Exception('Product not found');
  }

  Widget dropDownWidgetProduct({
    required List<Product> productList,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.black,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: productList.map((Product product) {
          return DropdownMenuItem<String>(
            value: product.name,
            child: Text(product.name),
          );
        }).toList(),
        value: BlocProvider.of<ProductCubit>(context).dropDownValue,
        onChanged: (String? newValue) {
          var p = getPriceByName(newValue ?? "");
          print("ppppp----$p");
          BlocProvider.of<ProductCubit>(context)
              .selectProduct(value: newValue ?? "");
          BlocProvider.of<ProductCubit>(context)
              .selectPrice(value: p.toString() ?? "");
        },
        style: const TextStyle(color: Colors.black),
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget dropDownWidgetCategory({
    required List<String> categoryList,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Colors.black,
            ),
            SizedBox(width: 4),
            Expanded(
              child: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: categoryList.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        value: BlocProvider.of<CategoryCubit>(context).dropDownValue,
        onChanged: (String? newValue) {
          BlocProvider.of<CategoryCubit>(context)
              .selectCategory(value: newValue!);
        },
        style: const TextStyle(color: Colors.black),
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget addItemWidget() {
    return Row(
      children: [
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Qty",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              TextFormField(
                controller: quantity,
                keyboardType: TextInputType.number,
                onSaved: (String? value) {},
                validator: (String? value) {
                  return (value != null && value.contains('@'))
                      ? 'Do not use the @ char.'
                      : null;
                },
              ),
            ],
          ),
        ),
        Flexible(
          flex: 3,
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red),
                  onPressed: () async {
                    if (quantity.text.isEmpty || quantity.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please add quantity'),
                        ),
                      );
                    } else {
                      BlocProvider.of<OrderCubit>(context).insertCartData(
                          name: BlocProvider.of<ProductCubit>(context)
                              .dropDownValue,
                          quantity: quantity.text,
                          unitPrice:
                              BlocProvider.of<ProductCubit>(context).selectP,
                          totalPrice: (int.parse(quantity.text) *
                                  double.parse(
                                      BlocProvider.of<ProductCubit>(context)
                                          .selectP))
                              .toString(),
                          netPrice: ((int.parse(quantity.text) *
                                      double.parse(
                                          BlocProvider.of<ProductCubit>(context)
                                              .selectP)) *
                                  (1 -
                                      BlocProvider.of<CustomerCubit>(context)
                                              .customerDataLocal[1]
                                              .discountPercentage /
                                          100))
                              .toString());
                    }
                  },
                  child: const Text(
                    "Add",
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.red),
            onPressed: () {},
            child: const Text(
              "Sub",
            ),
          ),
        ),
        Expanded(
          child: TextButton(
            style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                foregroundColor: Colors.white,
                backgroundColor: Colors.red),
            onPressed: () {},
            child: const Text(
              "Remove",
            ),
          ),
        )
      ],
    );
  }
}
