import 'dart:io';

import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/service_provider/dashbord_service_provider/components/sp_dashboard_body.dart';
import 'package:support_app/service_provider/dashbord_service_provider/sp_drawermenu.dart';

class SpDashboard extends StatefulWidget {
  const SpDashboard({super.key});
  static String routeName = '/sp_dashboard';
  @override
  State<SpDashboard> createState() => _DashboardState();
}

class _DashboardState extends State<SpDashboard> {
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
        appBar: AppBar(
          toolbarHeight: SizeConfig.screenHeight * 0.15,
          title: const Text("Technician Dashboard", style: TextStyle(fontWeight: FontWeight.w700,),),
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
        drawer:const SpDrawerMenu(),
        body: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(50),)
            ),
            child: const SpDashboardBody()
        ),
      ),
    );
  }
}

