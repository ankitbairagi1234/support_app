import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;

import '../../../../api_services/api_path.dart';
import '../../../../custom_widget/tockenstring.dart';
import '../../../../models/all_ticketsdetails_model.dart';


class RejectedTicketDetailsBody extends StatefulWidget {
  const RejectedTicketDetailsBody({Key? key}) : super(key: key);

  @override
  State<RejectedTicketDetailsBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<RejectedTicketDetailsBody> {



  TextEditingController descriptionController = TextEditingController();


  var addrating;

  bool isLoading = false;

  // List<AllTicketData> getAllTicketDetails = [];
  AllTicketDetailsModel? getAllTicketDetails;

  getResolvedTicketDetails() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}ticketDetails'));
    request.fields.addAll({
      'id': '$userId',
      'ticket_id':'9'
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = AllTicketDetailsModel.fromJson(json.decode(finalResponse));
      print("$jsonResponse");
      print("_______________$finalResponse");
      setState(() {
        getAllTicketDetails = jsonResponse;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }
  addFeedBack() async {
    print('____________$addrating');
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");
    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/create_feedback'));
    request.fields.addAll({
      'id': '$userId',
      'service_id': '17',
      'technician_id': '25',
      'ticket_id': '17',
      'stars_number':addrating== null?'1': addrating.toString(),
      'description': descriptionController.text
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print('final response here ${jsonResponse['data']} and ');

      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        setState(() {
          print("final response here ${jsonResponse}");

        });
        Navigator.pop(context);
      }
      else{
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResolvedTicketDetails();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return getAllTicketDetails == null ? const Center(child: CircularProgressIndicator(
      semanticsLabel: 'Circular progress indicator',
    ),) :getAllTicketDetails!.data! ==0?Center(child:Text("No data to show",style: TextStyle(fontSize: 20),),) :
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ticket Number :${getAllTicketDetails!.data!.ticket}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
              ],
            ),
            const SizedBox(height: 20,),

            Text("Product Name :${getAllTicketDetails!.data!.productName}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),

            const SizedBox(height: 30,),
            const Text("Product Image :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getAllTicketDetails!.data!.productImage}",),
            const SizedBox(height: 30,),
            const Text("Issues Image :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getAllTicketDetails!.data!.image}",),
            const SizedBox(height: 30,),
            const Text(" Invoice :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getAllTicketDetails!.data!.productInvoice}",),
            const SizedBox(height: 30,),
            const Text("Warranty Card :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getAllTicketDetails!.data!.warrantyCard}",),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Purchase Date :${getAllTicketDetails!.data!.purchasedDate}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Text("Invoice Date :${getAllTicketDetails!.data!.invoiceDate}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
              ],
            ),
            const SizedBox(height: 20,),
            Text("Warranty Date :${getAllTicketDetails!.data!.warrantyDate}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            const SizedBox(height: 30,),
            const Text("Issues Description :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text("${getAllTicketDetails!.data!.description}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),


            const SizedBox(height: 30,),
            Row(
              children: [
                const Text("Task Status :  ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Container(
                    height: 30,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green,width: 2)),
                    child: Center(child: Text(" ${getAllTicketDetails!.data!.proStatus}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.green),))),
              ],
            ),

            const SizedBox(height: 30,),

            Row(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Text("Close",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                  ),
                ),
              ],
            )
          ],),
      ),
    );
  }
  Future<void> _workDoneFeedback(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Feedback'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(' Rating',style: TextStyle(color: Colors.black,fontSize: 18),),
                  SizedBox(height: 10,),


                  RatingBar.builder(
                    initialRating:  1,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      setState(() {
                        addrating = rating;
                        print('$addrating');
                      });
                    },
                  ),
                  const SizedBox(height: 30,),
                  const Text('Description',style: TextStyle(color: Colors.black,fontSize: 18),),
                  SizedBox(height: 20,),
                  Container(
                    height: 80,
                    width: SizeConfig.screenWidth*7/5,
                    decoration:  const BoxDecoration(
                      color:   Color(0xffDEEEFA),
                      borderRadius:  BorderRadius.all(Radius.circular(15)),
                    ),
                    child:  TextFormField(
                      controller: descriptionController,
                      keyboardType:TextInputType.emailAddress,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Description",
                        hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
                      ),
                    ),

                  ),

                  SizedBox(height: 60,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          setState(() {
                            isLoading = false;
                          });
                          if(descriptionController.text.isEmpty ){
                            Fluttertoast.showToast(msg: "The description field is required.");
                            setState(() {
                              isLoading = false;
                            });
                          } else{
                            addFeedBack();
                          }
                          // Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 90,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
          );
        });
  }
}
