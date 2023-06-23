import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/screens/eCatalogue/components/ecatalouge_body.dart';
import 'package:support_app/widgets/drawer_menu.dart';
class ECatalogue extends StatelessWidget {
  const ECatalogue({Key? key}) : super(key: key);
  static String routeName = '/ecatalogue';
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        toolbarHeight: SizeConfig.screenHeight * 0.15,
        title: Padding(
          padding:  EdgeInsets.only(left: SizeConfig.screenWidth*0.2),
          child: const Text("eCatalogue", style: TextStyle(fontWeight: FontWeight.w700,),),
        ),
        backgroundColor: const Color(0xff376AA9),
        elevation: 0,

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
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(45),)
          ),
          child: const EcatalogueBody()
      ),
    );
  }
}
