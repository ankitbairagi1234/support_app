import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';

import 'package:http/http.dart'as http;
import 'package:support_app/service_provider/rejected_task/rejected_task.dart';
import 'package:support_app/service_provider/total_task/total_task.dart';

import '../../../api_services/api_path.dart';
import '../../../custom_widget/tockenstring.dart';
import '../../../models/provider_count.dart';
import '../../active_task/active_task.dart';
import '../../resolved_task/resolved_task.dart';


class SpDashboardBody extends StatefulWidget {
  const SpDashboardBody({Key? key}) : super(key: key);

  @override
  State<SpDashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<SpDashboardBody> {

  ProviderCount? dashboardCount;

  dashboardCounting() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("__this Is user id$userId");
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}provider_count'));
    request.fields.addAll({
      'id': '$userId'
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = ProviderCount.fromJson(json.decode(finalResponse));


      print("$jsonResponse");
      print("finalResponse");
      setState(() {
        dashboardCount = jsonResponse;
      });
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboardCounting();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final double itemHeight = (SizeConfig.screenHeight - kToolbarHeight - 120) / 1.8;
    final double itemWidth = SizeConfig.screenWidth / 0.7;
    return dashboardCount == null? const Center(child: CircularProgressIndicator(
      semanticsLabel: 'Circular progress indicator',
    ),) :GridView.count(
      padding: const EdgeInsets.only(top: 45, left: 35, right: 35,),
      // margin:const EdgeInsets.only(left: 35, right: 35),
      crossAxisSpacing: 15,
      mainAxisSpacing: 5,
      crossAxisCount: 2,
      childAspectRatio: (itemWidth / itemHeight),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: [
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, TotalTask.routeName);
          },
          child: Container(
            height: 300,
            decoration: const BoxDecoration(
              color: Color(0xffC1D3FF),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black38, //New
                  blurRadius: 1.0,
                )
              ],
            ),

            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 15),
                  child: Text("Total Task", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff376AA9),),),
                ),

                Divider(height: 5, thickness: 0.35, color: Color(0xff376AA9),),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("${dashboardCount!.data?.task}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff376AA9),),),
                ),
                // Text("View Products"),
                // Icon(Icons.remove_red_eye_outlined)
              ],
            ),
          ),
        ),
        // InkWell(
        //   onTap: (){
        //     Navigator.pushNamed(context, ECatalogue.routeName);
        //   },
        //   child: Container(
        //     decoration: const BoxDecoration(
        //       color: Color(0xffC1D3FF),
        //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //       boxShadow: [
        //         BoxShadow(color: Colors.black38, blurRadius: 1.0),
        //       ]
        //     ),
        //
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: EdgeInsets.only(top: 15, bottom: 15),
        //           child: Text("e-Catalogue", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff376AA9),),),
        //         ),
        //         Divider(height: 5, thickness: 0.35, color: Color(0xff376AA9),),
        //         Padding(
        //           padding: EdgeInsets.only(top: 10),
        //           child: Text("${dashboardCount!.data!.eCatalogue}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff376AA9),),),
        //         ),
        //         // Icon(Icons.remove_red_eye_outlined)
        //       ],
        //     ),
        //   ),
        // ),
        //
        // InkWell(
        //   onTap: (){
        //     // Navigator.pushNamed(context, Stores.routeName);
        //   },
        //   child: Container(
        //     decoration: const BoxDecoration(
        //         color: Color(0xffFFCCD8),
        //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //         boxShadow: [
        //           BoxShadow(color: Colors.black38, blurRadius: 1.0),
        //         ]
        //     ),
        //
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: EdgeInsets.only(top: 15, bottom: 15),
        //           child: Text("Stores", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff480011),),),
        //         ),
        //         Divider(height: 5, thickness: 0.35, color: Color(0xff480011)),
        //         Padding(
        //           padding: EdgeInsets.only(top: 10),
        //           child: Text("${dashboardCount!.data!.totalStore}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff480011),),),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        //
        //
        // InkWell(
        //   onTap: (){ Navigator.pushNamed(context, History.routeName); },
        //   child: Container(
        //     decoration: const BoxDecoration(
        //         color: Color(0xffFFCCD8),
        //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //         boxShadow: [
        //           BoxShadow(color: Colors.black38, blurRadius: 1.0),
        //         ]
        //     ),
        //
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        //           child: Text("History", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff480011),),),
        //         ),
        //         Divider(height: 5, thickness: 0.35, color: Color(0xff480011),),
        //         Padding(
        //           padding: EdgeInsets.only(top: 10),
        //           child: Text("${dashboardCount!.data!.servicesHistory}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff480011),),),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        InkWell(
          onTap: (){
            Navigator.pushNamed(context, ActiveTask.routeName);

            // Navigator.pushNamed(context, Ticket.routeName);
            },
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0xffFFE8BF),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 1.0),
                ]
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text(" Active Tickets", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,  color: Color(0xff6D4E17)),),
                ),
                Divider(height: 5, thickness: 0.35, color: Color(0xff6D4E17),),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("${dashboardCount!.data?.activeTask}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff6D4E17),),),
                ),
              ],
            ),
          ),
        ),
        // InkWell(
        //   onTap: (){
        //     // Navigator.pushNamed(context, ActiveTicket.routeName);
        //   },
        //   child: Container(
        //     decoration: const BoxDecoration(
        //         color: Color(0xffFFE8BF),
        //         borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //         boxShadow: [
        //           BoxShadow(color: Colors.black38, blurRadius: 1.0),
        //         ]
        //     ),
        //
        //     child: Column(
        //       children: [
        //         Padding(
        //           padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        //           child: Text("Active Tickets", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff6D4E17)),),
        //         ),
        //         Divider(height: 5, thickness: 0.35, color: Color(0xff6D4E17),),
        //         Padding(
        //           padding: EdgeInsets.only(top: 10),
        //           child: Text("${dashboardCount!.data?.activeTicket}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff6D4E17),),),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),

        InkWell(
          onTap: (){
            Navigator.pushNamed(context, ResolvedTask.routeName);
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Color(0xffB2DBB9),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 1.0),
                ]
            ),

            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text("Resolved Tickets", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff076A18)),),
                ),
                Divider(height: 8, thickness: 0.35, color: Color(0xff076A18),),
                Padding(
                  padding: EdgeInsets.only(top: 10,),
                  child: Text("${dashboardCount!.data?.doneTask}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Color(0xff076A18),),),
                ),
              ],
            ),
          ),
        ),

        InkWell(
          onTap: (){
            Navigator.pushNamed(context, RejectedTask.routeName);
          },
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                boxShadow: [
                  BoxShadow(color: Colors.black38, blurRadius: 1.0),
                ]
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Text("Rejected Tickets", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),),
                ),
                Divider(height: 8, thickness: 0.35, color: Color(0xff076A18),),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("${dashboardCount!.data?.rejectTask}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white,),),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

