
import 'package:flutter/material.dart';
import 'package:support_app/screens/tickets/ticket_details/comonents/rejected_ticket_details_body.dart';

import 'package:support_app/widgets/drawer_menu.dart';

import 'comonents/active_ticket_details_body.dart';


class RejectedTicketDetails extends StatelessWidget {
  const RejectedTicketDetails({Key? key}) : super(key: key);
  static String routeName = '/rejected_ticket_details';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Center(child: Text("Rejected Tickets Details")),
        backgroundColor: const Color(0xff376AA9),
        elevation: 0.0,
        centerTitle: true,
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
            borderRadius: BorderRadius.only(topRight: Radius.circular(50),)
        ),
        // margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.only(top:20),
        child: const RejectedTicketDetailsBody(),
      ),
    );
  }
}
