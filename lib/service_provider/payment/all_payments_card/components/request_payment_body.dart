
import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/service_provider/payment/approved_payment/approved_payment.dart';
import 'package:support_app/service_provider/payment/done_payment/done_payment.dart';
import 'package:support_app/service_provider/payment/panding_payment/panding_payment.dart';

import '../../request_paymenrt_list/request_payment_list.dart';

class PaymentCardBody extends StatefulWidget {
  const PaymentCardBody({Key? key}) : super(key: key);

  @override
  State<PaymentCardBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<PaymentCardBody> {

  String? taskId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    SizeConfig().init(context);
    final double itemHeight = (SizeConfig.screenHeight - kToolbarHeight - 120) / 1.8;
    final double itemWidth = SizeConfig.screenWidth / 0.7;

    return GridView.count(
      padding: const EdgeInsets.only(top: 45, left: 35, right: 35,),
      // margin:const EdgeInsets.only(left: 35, right: 35),
      crossAxisSpacing: 15,
      mainAxisSpacing: 5,
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / itemHeight),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, RequestPaymentPaymentList.routeName);
          },
          child: Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Color(0xffC1D3FF),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38, //New
                  blurRadius: 1.0,
                )
              ],
            ),

            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text("Request Payment", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff376AA9),),),
                ),

              ],
            ),
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, PendingPayment.routeName);

            // Navigator.pushNamed(context, Ticket.routeName);
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0xffFFE8BF),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 1.0),
                ]
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text("Panding Payment", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,  color: Color(0xff6D4E17)),),
                ),

              ],
            ),
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, ApprovedPayment.routeName);
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0xffB2DBB9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 1.0),
                ]
            ),

            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text("Approved Payment ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff076A18)),),
                ),

              ],
            ),
          ),
        ),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, DonePayment.routeName);
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 1.0),
                ]
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text("Done Payment", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
