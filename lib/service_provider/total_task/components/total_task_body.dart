import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;

import '../../../custom_widget/tockenstring.dart';
import '../../../models/total_task_model.dart';
import '../../total_task_details/total_task_details.dart';

class TotalTaskBody extends StatefulWidget {
  const TotalTaskBody({Key? key}) : super(key: key);

  @override
  State<TotalTaskBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<TotalTaskBody> {

  String? taskId;


  TotalTask? totalTaskList;

  totalTask() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);
    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/taskList'));
    request.fields.addAll({
      'id': '$userId',
      'task_status': '0'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonRsponse = TotalTask.fromJson(jsonDecode(finalResponse));

      print("$jsonRsponse");
      print("__overprotects$finalResponse");
      setState(() {
        totalTaskList = jsonRsponse;
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
    totalTask();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return totalTaskList == null ? const Center(child: CircularProgressIndicator(
      semanticsLabel: 'Circular progress indicator',
    ),) :totalTaskList!.data!.length ==0?Center(child:Text("No data to show",style: TextStyle(fontSize: 20),),) :
    ListView.builder(
      itemBuilder: (context, index){
        int id = index + 1;
        return SingleChildScrollView(
          child: Column(
            children: [
              (id==1)? const SizedBox(height: 40,) :const SizedBox(height:20,),
              InkWell(
                onTap: (){
                  print("${totalTaskList!.data![index].ticketId}");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskDetails()));

                },
                child: Card(
                  margin:const EdgeInsets.only(left: 35, right: 35),
                  elevation: 4.0, // adds a shadow to the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // adds rounded corners to the card
                    side:const  BorderSide(
                      color: Colors.transparent, // sets the color of the border
                      width: 0.1, // sets the width of the border
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color:   Color(0xff376AA9),
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(9), bottomLeft: Radius.circular(9)),
                        ),
                        width: SizeConfig.containWidth,
                        height: SizeConfig.containHeight,
                        child: Padding(
                          padding: const EdgeInsets.only(top:30.0),
                          child: Text("SN\n$id", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
                        ),
                      ),
                      // Container(
                      //   width: SizeConfig.productImageWidth,
                      //   height: SizeConfig.productContainHeight,
                      //   padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                      //   // color:  Colors.green,
                      //   child: ClipRRect(
                      //       borderRadius: BorderRadius.circular(10),
                      //       child: Image.network('https://cubixsys.com/cubixsys-support/${totalTaskList!.data![index].}', fit: BoxFit.cover, height: SizeConfig.productImageHeight, width: SizeConfig.productImageWidth,)),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${totalTaskList!.data![index].ticket}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Text("${totalTaskList!.data![index].productName} ", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20 ), ),
                            SizedBox(height: 10,),

                            Text("${totalTaskList!.data![index].city}\n${totalTaskList!.data![index].state}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15 ),),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child:Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.green,width: 2)
                                ),
                                child: Text("${totalTaskList!.data![index].tasksStatus}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                            SizedBox(height: 20,),
                            Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.red,width: 2)
                                ),
                                child: Text("${totalTaskList!.data![index].priorityStatus}",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),))
                          ],
                        ),

                      ),



                      // InkWell(
                      //   onTap: (){
                      //     print('${totalTaskList!.data![index].taskId}');
                      //     Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskDetails()));
                      //     // Navigator.pushNamed(context, TaskDetails.routeName);
                      //   },
                      //   child: Container(
                      //     // width: SizeConfig.productViewButtonWidth,
                      //     // height: SizeConfig.productViewButtonHeight,
                      //     decoration: const BoxDecoration(
                      //       color:   Color(0xff376AA9),
                      //       borderRadius: BorderRadius.all(Radius.circular(5)),
                      //     ),
                      //     child:  const Padding(
                      //       padding: EdgeInsets.only(top:7.0, left:10.0),
                      //       child: Text("Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        );
      }, itemCount: totalTaskList?.data?.length,);
  }
}
