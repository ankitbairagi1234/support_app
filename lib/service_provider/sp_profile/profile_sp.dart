import 'package:flutter/material.dart';
import 'package:support_app/screens/profile/components/profile_body.dart';
import 'package:support_app/widgets/drawer_menu.dart';

import '../dashbord_service_provider/sp_drawermenu.dart';
import 'components/sp_profile_body.dart';
class SpProfile extends StatelessWidget {
  const SpProfile({Key? key}) : super(key: key);
  static String routeName = "/sp_profile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        toolbarHeight: 80,
        title:  Padding(
          padding:  EdgeInsets.only(left: MediaQuery.of(context).size.width*0.3),
          child:  const Text("Profile",  style: TextStyle(fontWeight: FontWeight.normal),),
        ),
        backgroundColor: const Color(0xff376AA9),
        elevation: 0.0,

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
            borderRadius: BorderRadius.only(topRight: Radius.circular(50),)
        ),
        // margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.only(top:20),
        child: const SpProfileBody(),
      ),
    );
  }
}
