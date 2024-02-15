import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_integration/home/cubit/home_cubit.dart';
import 'package:firebase_integration/login/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const routeName = '/HomePage';

  static Route route(RouteSettings settings) {
    return MaterialPageRoute(
        settings: settings,
        builder: (context) => BlocProvider(
            create: (context) => HomeCubit(), child: const HomePage()));
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    final homeCubit = context.read<HomeCubit>();
    homeCubit.fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final auth = FirebaseAuth.instance;
    final homeCubit = context.read<HomeCubit>();

    return Scaffold(
      body: Column(
        children: [
          Text('currentUser ${user!.email}'),
          StreamBuilder(
              stream: homeCubit.fetchUser(),
              builder: (context, cxt) {
                if (cxt.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: cxt.data!.length,
                      itemBuilder: (context, index) {
                        final data = cxt.data![index];
                        return Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name  :${data.name}'),
                                Text('Email :${data.email}'),
                              ],
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
          GestureDetector(
              onTap: () {
                auth.signOut().then((value) =>
                    Navigator.pushNamed(context, LoginPage.routeName));
              },
              child: Container(
                  decoration: const BoxDecoration(color: Colors.red),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Log Out'),
                  ))),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );

  }
  void bottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    showModalBottomSheet(
        isDismissible: true,
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: ageController,
                  decoration: InputDecoration(
                    hintText: 'Enter age',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                    onTap: () {
                      // createData(nameController.text, ageController.text);
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: const BoxDecoration(color: Colors.red),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('submit'),
                        ))),
              ],
            ),
          );
        });
  }

}
