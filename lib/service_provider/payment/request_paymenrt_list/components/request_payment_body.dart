import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;

import '../../../../custom_widget/tockenstring.dart';
import '../../../../models/payment_model.dart';



class RequestPaymentListBody extends StatefulWidget {
  const RequestPaymentListBody({Key? key}) : super(key: key);

  @override
  State<RequestPaymentListBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<RequestPaymentListBody> {

  String? taskId;


  AllPaymentModel? allPayment;

  requestPayment() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);
    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/payments_list'));
    request.fields.addAll({
      'id': '$userId',
      'status': '4'
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = AllPaymentModel.fromJson(jsonDecode(finalResponse));

      print("$jsonResponse");
      print("__overprotects$finalResponse");
      setState(() {
        allPayment = jsonResponse;
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
    requestPayment();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return allPayment == null ? const Center(child: CircularProgressIndicator(
      semanticsLabel: 'Circular progress indicator',
    ),) :allPayment!.data!.isEmpty?const Center(child:Text("No data to show",style: TextStyle(fontSize: 20),),) :
    ListView.builder(
      itemBuilder: (context, index){
        int id = index + 1;
        return SingleChildScrollView(
          child: Column(
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0,left: 10),
                          child: Text("${allPayment!.data![index].ticket}",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        ),
                        SizedBox(
                          width: SizeConfig.productMiddleWidth,
                          child:  ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                              child: Text("${allPayment!.data![index].name} ", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20 ), ),
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.only(bottom: 8.0),
                              child: Text("${allPayment!.data![index].toBePaid}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18 ),),
                            ),
                          ),
                        ),

                      ],
                    ),
                    InkWell(
                      onTap: (){
                        print('${allPayment!.data![index].id}');
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskDetailsBody()));
                        // Navigator.pushNamed(context, TaskDetails.routeName);
                      },
                      child: Container(
                        width: SizeConfig.productViewButtonWidth,
                        height: SizeConfig.productViewButtonHeight,
                        decoration: const BoxDecoration(
                          color:   Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Center(child: Text("${allPayment!.data![index].status}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),)),
                      ),
                    ),
                    const SizedBox(width: 5,),
                    InkWell(
                      onTap: (){
                        print('${allPayment!.data![index].id}');
                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskDetailsBody()));
                        // Navigator.pushNamed(context, TaskDetails.routeName);
                      },
                      child: Container(
                        width: SizeConfig.productViewButtonWidth,
                        height: SizeConfig.productViewButtonHeight,
                        decoration: const BoxDecoration(
                          color:   Color(0xff376AA9),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child:  const Padding(
                          padding: EdgeInsets.only(top:7.0, left:10.0),
                          child: Text("View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }, itemCount: allPayment?.data?.length,);
  }
}
