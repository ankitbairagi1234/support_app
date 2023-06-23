import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/widgets/drawer_menu.dart';

import 'components/resolved_task_details_body.dart';



class ResolvedTaskDetails extends StatelessWidget {
  const ResolvedTaskDetails({Key? key, }) : super(key: key);
  static String routeName = "/resolve_taskDetails";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: SizeConfig.screenHeight * 0.15,
        title: const Text("Resolved Task Details", style: TextStyle(fontWeight: FontWeight.w700,),),
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
      body:   Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(45),)
          ),
          child: const ResolvedTaskDetailsBody()
      ),
    );
  }
}
