import 'package:firebase_integration/product/cubit/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  static const routeName = '/cartScreen';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const CartScreen());
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List controllerList = <ControllerModel>[];

  void addController() {
    controllerList.add(ControllerModel(
        nameCon: TextEditingController(),
        emailCon: TextEditingController(),
        phoneCon: TextEditingController()));
  }

  @override
  void initState() {
    super.initState();
    addController();
  }

  @override
  Widget build(BuildContext context) {
    final productCubit = context.read<ProductCubit>();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 500,
              width: 500,
              child: ListView.builder(
                  itemCount: controllerList.length,
                  itemBuilder: (context, index) {
                    final data = controllerList[index];
                    return customContainer(data);
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(dataList: controllerList)));
                    });
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('Submit')),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      addController();
                    });
                  },
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text('Add')),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    //   Scaffold(
    //   body: Padding(
    //     padding: const EdgeInsets.all(15.0),
    //     child: Center(
    //       child: SizedBox(
    //         width:1200 ,
    //         height: double.infinity,
    //         child: Row(
    //           children: [
    //             Container(
    //               width: 650,
    //               height: double.infinity,
    //              decoration: BoxDecoration(
    //                image: DecorationImage(
    //                  image: NetworkImage(productCubit.state.selectedProduct.imageUrl),
    //                  fit: BoxFit.cover
    //                )
    //              ),
    //             )
    //           ],
    //         ),
    //       ),
    //     )
    //     // Column(
    //     //   children: [
    //     //     // CustomIcon(icon:AppIcons.arrowBackward),
    //     //     Expanded(
    //     //       child: Container(
    //     //         color: Colors.green,
    //     //         width: 700,
    //     //       ),
    //     //     )
    //     //   ],
    //     // ),
    //   ),
    // );
  }

  Widget customContainer(ControllerModel data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(5)),
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              customTextField(hintText: 'name', controller: data.nameCon),
              customTextField(hintText: 'email', controller: data.emailCon),
              customTextField(hintText: 'phone', controller: data.phoneCon),
            ],
          ),
        ),
      ),
    );
  }

  Widget customTextField(
      {required String hintText, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class ControllerModel {
  const ControllerModel(
      {required this.nameCon, required this.emailCon, required this.phoneCon});

  final TextEditingController nameCon;

  final TextEditingController emailCon;

  final TextEditingController phoneCon;
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.dataList});

  final List dataList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, i) {
                    final data = dataList[i];
                    return detailContainer(data: data);
                  }))
        ],
      ),
    );
  }

  Widget detailContainer({required ControllerModel data}) {
    return SizedBox(
      child: Column(
        children: [
          Text(data.nameCon.text),
          Text(data.emailCon.text),
          Text(data.phoneCon.text),
        ],
      ),
    );
  }
}
