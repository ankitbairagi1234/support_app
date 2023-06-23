import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/screens/product/components/prodcut_body.dart';
import 'package:support_app/screens/tickets/add_tickets.dart';
import 'package:support_app/utils/colour.dart';
import 'package:support_app/widgets/drawer_menu.dart';

class Product extends StatelessWidget {
  const Product({Key? key}) : super(key: key);
  static String routeName = "/product";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 5.0,left: 20,right: 20),
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, AddTicket.routeName);
          },
          child: Container(
            height: 50,
            // width: 150,
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Text('Add New Product',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.bold,),)),

          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: SizeConfig.screenHeight * 0.15,
        title: const Text("Products", style: TextStyle(fontWeight: FontWeight.w700,),),
        backgroundColor: const Color(0xff376AA9),
        elevation: 0,

        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              padding: const EdgeInsets.only(left: 10),
              icon: Image.asset('assets/icons/drawer_icon.png', height: 20,),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,

            );
          },
        ),
      ),
      drawer: const DrawerMenu(),
      body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(45),)
            ),
            child: const ProductBody()
      ),
    );
  }
}
