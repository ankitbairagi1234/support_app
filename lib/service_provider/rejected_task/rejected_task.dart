import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/service_provider/dashbord_service_provider/sp_drawermenu.dart';
import 'package:support_app/service_provider/resolved_task/components/resolved_task_body.dart';

import 'components/rejected_task_body.dart';



class RejectedTask extends StatelessWidget {
  const RejectedTask({Key? key}) : super(key: key);
  static String routeName = "/rejected_task";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),


      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: SizeConfig.screenHeight * 0.15,
        title: const Text("Rejected Task", style: TextStyle(fontWeight: FontWeight.w700,),),
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
      body:   Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(45),)
          ),
          child: const RejectedTaskBody()
      ),
    );
  }
}
