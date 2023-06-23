
import 'package:flutter/material.dart';
import 'package:support_app/screens/tickets/add_tickets.dart';
import 'package:support_app/screens/tickets/components/rejected_ticket_body.dart';
import 'package:support_app/screens/tickets/components/resolved_ticket_body.dart';
import 'package:support_app/screens/tickets/components/tickets_body.dart';
import 'package:support_app/utils/colour.dart';
import 'package:support_app/widgets/drawer_menu.dart';

import 'components/active_ticket_body.dart';

class RejectedTicket extends StatelessWidget {
  const RejectedTicket({Key? key}) : super(key: key);
  static String routeName = '/rejected_ticket';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Center(child: Text("Rejected Tickets")),
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
        child: const RejectedTicketBody(),
      ),
    );
  }
}
