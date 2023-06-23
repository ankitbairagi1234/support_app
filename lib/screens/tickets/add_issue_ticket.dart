import 'package:flutter/material.dart';
import 'package:support_app/screens/tickets/components/addtickets_body.dart';
import 'package:support_app/screens/tickets/components/tickets_body.dart';
import 'package:support_app/utils/colour.dart';
import 'package:support_app/widgets/drawer_menu.dart';

import 'components/add_issue_ticket_body.dart';

class TicketIssue extends StatelessWidget {
  const TicketIssue({Key? key}) : super(key: key);
  static String routeName = '/add_ticket_issue';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Center(child: Text("Components/Add Ticket")),
        backgroundColor: const Color(0xff376AA9),
        elevation: 0.0,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
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
        child: const AddIssueTicketBody(),
      ),
    );
  }
}