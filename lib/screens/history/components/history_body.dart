
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;
import 'package:support_app/models/sp_feedback_model.dart';

import '../../../custom_widget/tockenstring.dart';

class HistoryBody extends StatefulWidget {
  const HistoryBody({Key? key}) : super(key: key);

  @override
  State<HistoryBody> createState() => _HistoryBodyState();
}

class _HistoryBodyState extends State<HistoryBody> {

  SpFeedBackModel? getSpFeedback;

  getService() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);
    print("${userId}");
    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/performance'));
    request.fields.addAll({
      'id': '$userId'
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response .stream.bytesToString();
      final jsonResponse = SpFeedBackModel.fromJson(jsonDecode(finalResponse));
      print("_this is over services_________$finalResponse");
      setState(() {
        getSpFeedback = jsonResponse;
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
    getService();
  }
  int? rating;


  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);

    return Column(
      children: [
        const SizedBox(height: 20,),
        // Card(
        //   margin:const EdgeInsets.only(left: 35, right: 35),
        //   elevation: 4.0,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(10.0),
        //     side:const  BorderSide(
        //       color: Colors.transparent,
        //       width: 0.1,
        //     ),
        //   ),
        //   child: TextFormField(
        //         decoration:   InputDecoration(
        //           enabledBorder: OutlineInputBorder(
        //             borderSide: const BorderSide(
        //               color: Colors.transparent,
        //             ),
        //             borderRadius: BorderRadius.circular(10.0),
        //           ),
        //           focusedBorder: OutlineInputBorder(
        //             borderSide: const BorderSide(
        //             color: Colors.transparent,
        //             ),
        //             borderRadius: BorderRadius.circular(10.0),
        //           ),
        //           hintText: "Enter ticket number..",
        //           prefixIcon:  const Icon(Icons.search, color: Colors.grey, size: 30,),
        //       ),
        //   ),
        // ),
        Expanded(
          child:getSpFeedback == null ? const Center(child: CircularProgressIndicator(
            semanticsLabel: 'Circular progress indicator',
          ),) :getSpFeedback!.data!.isEmpty?const Center(child:Text("No data to show",style: TextStyle(fontSize: 20),),) : ListView.builder(itemBuilder: (context, index){
            int id = index + 1;
            return  Column(
              children: [
                (id==1)? const SizedBox(height: 40,) :const SizedBox(height:20,),
                Card(
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
                        height: SizeConfig.screenHeight*30/10/15,

                        child: Padding(
                          padding: const EdgeInsets.only(top:30.0),
                          child: Text("Sn\n$id", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
                        ),
                      ),
                      Container(
                        width: SizeConfig.screenWidth*110/10/20,
                        height: SizeConfig.screenHeight*30/10/15,
                        color:  Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 15),
                              child: Text("Name : ${getSpFeedback!.data![index].name} ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20 ), ),
                            ),
                            Padding(
                              padding:  EdgeInsets.only(left: 15.0),
                              child:  Text("${getSpFeedback!.data![index].email}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,  ), ),
                            ),
                            ListTile(
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                       width : 280,
                                    child:
                                    Text("${getSpFeedback!.data![index].description}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15 ),overflow: TextOverflow.ellipsis,maxLines: 5,)
                                    ),
                              ),
                              subtitle: RatingBarIndicator(
                                rating: getSpFeedback!.data![index].stars!.toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 23.0,
                                direction: Axis.horizontal,
                              ),

                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }, itemCount: getSpFeedback?.data?.length,),
        ),
      ],
    );
  }
}
