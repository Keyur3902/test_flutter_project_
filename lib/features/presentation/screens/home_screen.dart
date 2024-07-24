import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_flutter_project/features/presentation/cubits/order_cubit/order_state.dart';
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
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController quantity = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderCubit>(context).getCartItemList();
    BlocProvider.of<CustomerCubit>(context).getCustomerDataFromLocal();
    BlocProvider.of<CategoryCubit>(context).getCategoryDataFromLocal();
    BlocProvider.of<ProductCubit>(context).getProductDataFromLocal();
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
              },
              icon: const Icon(
                Icons.replay_outlined,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            BlocBuilder<OrderCubit, OrderState>(builder: (context, orderState) {
          return BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, categoryState) {
            return BlocBuilder<ProductCubit, ProductState>(
                builder: (context, productState) {
              return BlocBuilder<CustomerCubit, CustomerState>(
                  builder: (context, customerState) {
                if (productState is ProductLoadingState ||
                    customerState is CustomerLoadingState ||
                    categoryState is CategoryLoadingState ||
                    orderState is OrderLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return Column(
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
                        customerList: BlocProvider.of<CustomerCubit>(context)
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
                        categoryList: BlocProvider.of<CategoryCubit>(context)
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
                        productList: BlocProvider.of<ProductCubit>(context)
                            .productDataLocal,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      addItemWidget(),
                      SizedBox(
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
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                color: Colors.black38,
                              ),
                              child: Text("Name"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                color: Colors.black38,
                              ),
                              child: Text("Qty"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                color: Colors.black38,
                              ),
                              child: Text("Unit Price"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                color: Colors.black38,
                              ),
                              child: Text("Total Price"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.black),
                                color: Colors.black38,
                              ),
                              child: Text("Net Price (%)"),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: BlocProvider.of<OrderCubit>(context).orderTable.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Row(
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
                                      color: Colors.white,
                                    ),
                                    child: Text(BlocProvider.of<OrderCubit>(context).orderTable[index].name),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      color: Colors.white,
                                    ),
                                    child: Text(BlocProvider.of<OrderCubit>(context).orderTable[index].quantity),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      color: Colors.white,
                                    ),
                                    child: Text(BlocProvider.of<OrderCubit>(context).orderTable[index].unitPrice),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      color: Colors.white,
                                    ),
                                    child: Text(BlocProvider.of<OrderCubit>(context).orderTable[index].totalPrice),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      color: Colors.white,
                                    ),
                                    child: Text(BlocProvider.of<OrderCubit>(context).orderTable[index].netPrice),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      )
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
          BlocProvider.of<CustomerCubit>(context).selectProduct(value: newValue!);
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
    for (var product in BlocProvider.of<ProductCubit>(context).productDataLocal) {
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
          var p = getPriceByName(newValue??"");
          print("ppppp----$p");
          BlocProvider.of<ProductCubit>(context).selectProduct(value: newValue??"");
          BlocProvider.of<ProductCubit>(context).selectPrice(value: p.toString()??"");
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
          BlocProvider.of<CategoryCubit>(context).selectCategory(value: newValue!);
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
                    BlocProvider.of<OrderCubit>(context).insertCartData(
                        name: BlocProvider.of<ProductCubit>(context).dropDownValue,
                        quantity: quantity.text,
                        unitPrice: BlocProvider.of<ProductCubit>(context).selectP,
                        totalPrice: (int.parse(quantity.text) * double.parse(BlocProvider.of<ProductCubit>(context).selectP))
                            .toString(),
                        netPrice: (
                            (int.parse(quantity.text) * double.parse(BlocProvider.of<ProductCubit>(context).selectP)) * (1 - BlocProvider.of<CustomerCubit>(context)
                                .customerDataLocal[1]
                                .discountPercentage / 100)
                        ).toString());
                  },
                  child: const Text(
                    "Add",
                  ),
                ),
              ),
            ],
          ),
        ),
        // TextButton(
        //   style: TextButton.styleFrom(
        //       shape: const RoundedRectangleBorder(
        //         borderRadius: BorderRadius.all(Radius.circular(5)),
        //       ),
        //       foregroundColor: Colors.white,
        //       backgroundColor: Colors.red),
        //   onPressed: () {},
        //   child: const Text(
        //     "Remove",
        //   ),
        // )
      ],
    );
  }
}
