
import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/service_provider/dashbord_service_provider/sp_drawermenu.dart';

import '../add_apyment_invoice/add_payment.dart';
import 'components/request_payment_body.dart';




class RequestPayment extends StatelessWidget {
  const RequestPayment({Key? key}) : super(key: key);
  static String routeName = "/request_payment";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: SizeConfig.screenHeight * 0.15,
        title: const Text("Payment  ", style: TextStyle(fontWeight: FontWeight.w700,),),
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
      drawer: const SpDrawerMenu(),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 55.0,left: 20,right: 20),
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(context, AddPayment.routeName);
          },
          child: Container(
            height: 50,
            // width: 150,
            decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Text('Add Invoice',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.bold,),)),
          ),
        ),
      ),
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(45),)
          ),
          child: const PaymentCardBody()
      ),
    );
  }
}
