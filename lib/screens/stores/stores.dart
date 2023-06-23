import 'package:flutter/material.dart';
import 'package:support_app/screens/stores/components/stores_body.dart';
import 'package:support_app/widgets/drawer_menu.dart';
class Stores extends StatelessWidget {
  const Stores({Key? key}) : super(key: key);
  static String routeName = '/stores';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Center(child: Text("Stores List")),
        backgroundColor: const Color(0xff376AA9),
        elevation: 0.0,
        // leading: Builder(
        //   builder: (BuildContext context) {
        //     return IconButton(
        //       padding: const EdgeInsets.only(left: 10),
        //       icon: Image.asset('assets/icons/drawer_icon.png', height: 20,),
        //       onPressed: () {
        //         Scaffold.of(context).openDrawer();
        //       },
        //       tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        //
        //     );
        //   },
        // ),
      ),
      // drawer: const DrawerMenu(),
      body:   Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(50),)
          ),
          // margin: const EdgeInsets.only(top: 30),
          padding: const EdgeInsets.only(top:20),
          child: const StoresBody()
      ),
    );
  }
}
