import 'dart:io';

import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/screens/dashboard/components/dashboard_body.dart';
import 'package:support_app/screens/tickets/add_tickets.dart';
import 'package:support_app/utils/colour.dart';
import 'package:support_app/widgets/drawer_menu.dart';

import '../tickets/new_ticket.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static String routeName = '/dashboard';
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit an App?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          ElevatedButton(
            onPressed: (){
              exit(0);
              // Navigator.pop(context,true);
              // Navigator.pop(context,true);
            },
            //return true when click on "Yes"
            child:Text('Yes'),
          ),
        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return  WillPopScope(
      onWillPop: showExitPopup,

      child: Scaffold(
        backgroundColor: const Color(0xff376AA9),
        bottomSheet: Padding(
          padding: const EdgeInsets.only(bottom: 25.0,left: 20,right: 20),
          child: InkWell(
            onTap: (){
              Navigator.pushNamed(context, Ticket.routeName);
              // Navigator.pushNamed(context, AddTicket.routeName);
              // Navigator.pushNamed(context, routeName)
            },
            child: Container(
              height: 50,
              // width: 150,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(child: Text('Add New Ticket',style: TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.bold,),)),

      ),
          ),
        ),
        appBar: AppBar(
          toolbarHeight: SizeConfig.screenHeight * 0.15,
          title: const Text("Home", style: TextStyle(fontWeight: FontWeight.w700,fontSize: 25),),
          centerTitle: true,
          backgroundColor: const Color(0xff376AA9),
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                padding: const EdgeInsets.only(left: 10),
                icon: Container(
                  padding: EdgeInsets.all(5),
                  height: 45,
                  width: 50,
                  decoration: BoxDecoration(
                    border:Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)
                  ),
                    child: Image.asset('assets/icons/drawer_icon.png', height: 20,)),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        drawer:const DrawerMenu(),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(50),)
            ),
            child: const DashboardBody()
        ),
      ),
    );
  }
}
