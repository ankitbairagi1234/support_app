
import 'package:flutter/material.dart';

class AppbarWidget extends StatefulWidget {
  const AppbarWidget({Key? key}) : super(key: key);

  @override
  State<AppbarWidget> createState() => _AppbarWidgetState();
}

class _AppbarWidgetState extends State<AppbarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      title: const Center(child: Text("Dashboard")),
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
    );
  }
}
