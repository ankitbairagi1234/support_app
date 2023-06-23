import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;
import 'package:support_app/screens/dashboard/dashboard.dart';

import '../../../../api_services/api_path.dart';
import '../../../../custom_widget/tockenstring.dart';
import '../../../../models/select_ticket_model.dart';
import '../../../../models/state_model.dart';
import '../../../../utils/colour.dart';
import '../../../dashbord_service_provider/dashboard.dart';



class AddPaymentBody extends StatefulWidget {
  const AddPaymentBody({Key? key}) : super(key: key);

  @override
  State<AddPaymentBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<AddPaymentBody> {

  TextEditingController customerAmountController = TextEditingController();
  TextEditingController selfAmountController = TextEditingController();
  TextEditingController tobePaidController = TextEditingController();

  File? customerInvoice;

  bool isLoading = false;
  _getCustomerInvoiceFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        customerInvoice = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getCustomerInvoiceFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        customerInvoice = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }



  File? selfInvoice;
  _selfInvoiceFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        selfInvoice = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _selfInvoiceFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        selfInvoice = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSelectedTicket();
  }
  SelectTicketModel? selectTicket;
  var stateid;
  var selectedValue;

  getSelectedTicket() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/uploadInvoiceTicket'));
    request.fields.addAll({
      'id': '$userId'
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var finalResponse  = await response.stream.bytesToString();
      final jsonResponse = SelectTicketModel.fromJson(json.decode(finalResponse));
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString(stateid, 'id');
      print("________________$stateid");
      setState(() {
        selectTicket = jsonResponse;

      });
    }
    else {
    print(response.reasonPhrase);
    }
  }


   sendPaymentRequest() async {
     SharedPreferences prefs  = await SharedPreferences.getInstance();
     String? userId =  prefs.getString(TokenString.userid);

     var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/createInvoice'));
     request.fields.addAll({
       'id': '$userId',
       'ticket_id': '$selectedValue',
       'technician_invoice_amount': selfAmountController.text,
       'to_be_paid': tobePaidController.text,
       'customer_invoice_amount': customerAmountController.text
     });
     selfInvoice == null ? null : request.files.add(await http.MultipartFile.fromPath('technician_invoice', selfInvoice!.path.toString()));
     customerInvoice == null ? null : request.files.add(await http.MultipartFile.fromPath('customer_invoice', customerInvoice!.path.toString()));

     http.StreamedResponse response = await request.send();

     if (response.statusCode == 200) {

       var finalResponse = await response.stream.bytesToString();
       final jsonResponse = json.decode(finalResponse);
       print("_____________this is json rseponse ${jsonResponse}");
       if(jsonResponse['status'] == 1){
         Fluttertoast.showToast(msg: '${jsonResponse['message']}');

         Navigator.pushNamed(context, SpDashboard.routeName);

       }
       else{
         setState(() {
         });
         Fluttertoast.showToast(msg: "${jsonResponse['message']}");
       }

     }
     else {
     print(response.reasonPhrase);
     }

   }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text('Customer invoice',style: TextStyle(color: Colors.black,fontSize: 18),),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return Container(
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Take Image From", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            ListTile(leading: Image.asset('assets/icons/cameraicon.png', scale: 1.5,),
                              title: Text('Camera', style: TextStyle(fontWeight: FontWeight.bold)),
                              onTap: (){
                                _getCustomerInvoiceFromCamera();
                              },
                            ),
                            ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                              title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                              onTap: (){
                                _getCustomerInvoiceFromGallery();
                              },
                            ),
                            ListTile(leading: Image.asset('assets/icons/cancle.png', scale: 1.5,),
                              title: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold)),
                              onTap: (){
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    });
              },

              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                // width: SizeConfig.screenWidth*7/1,
                decoration: BoxDecoration(
                  color:Color(0xffDEEEFA), borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: customerInvoice == null || customerInvoice!.path.isEmpty ?Center(child: Icon(Icons.upload,size: 40,)) : Image.file(customerInvoice!,height: 100,fit: BoxFit.fill,)
                ),
              ),
            ),

            SizedBox(height: 30,),

            const Text('Customer invoice amount',style: TextStyle(color: Colors.black,fontSize: 18),),
            SizedBox(height: 20,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/5,
              decoration:  const BoxDecoration(
                color:   Color(0xffDEEEFA),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
              ),
              child:  TextFormField(
                controller: customerAmountController,
                keyboardType:TextInputType.number,
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
                  hintText: "Enter Amount",
                  hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ),

            ),
            SizedBox(height: 30,),
            Text('Self invoice',style: TextStyle(color: Colors.black,fontSize: 18),),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                showModalBottomSheet(
                    context: context,
                    builder: (context){
                      return Container(
                        height: 250,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Take Image From", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),
                            ListTile(leading: Image.asset('assets/icons/cameraicon.png', scale: 1.5,),
                              title: Text('Camera', style: TextStyle(fontWeight: FontWeight.bold)),
                              onTap: (){
                                _selfInvoiceFromCamera();
                              },
                            ),
                            ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                              title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                              onTap: (){
                                _selfInvoiceFromGallery();
                              },
                            ),
                            ListTile(leading: Image.asset('assets/icons/cancle.png', scale: 1.5,),
                              title: Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold)),
                              onTap: (){
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ),
                      );
                    });
              },

              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                // width: SizeConfig.screenWidth*7/1,
                decoration: BoxDecoration(
                  color:Color(0xffDEEEFA), borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: selfInvoice == null || selfInvoice!.path.isEmpty ?Center(child: Icon(Icons.upload,size: 40,)) : Image.file(selfInvoice!,height: 100,fit: BoxFit.fill,)
                ),
              ),
            ),
            SizedBox(height: 30,),

            Text('Self invoice amount',style: TextStyle(color: Colors.black,fontSize: 18),),
            SizedBox(height: 20,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/5,
              decoration:  const BoxDecoration(
                color:   Color(0xffDEEEFA),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
              ),
              child:  TextFormField(
                controller: selfAmountController,
                keyboardType:TextInputType.number,
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
                  hintText: "Enter Amount",
                  hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ),
              // child: DropdownButtonFormField<String>(
              //   decoration: InputDecoration(
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(
              //         color: Colors.transparent,
              //       ),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(
              //         color: Colors.transparent,
              //       ),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              //   value: dropdownValue,
              //   items: <String>['Madhya Pradesh', 'Chandigarh', 'UP',].map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(
              //         value,
              //         style:const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
              //       ),
              //     );
              //   }).toList(),
              //   // Step 5.
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       dropdownValue = newValue!;
              //     });
              //   },
              // ),

            ),
            SizedBox(height: 30,),

            Text('To be paid amount',style: TextStyle(color: Colors.black,fontSize: 18),),
            SizedBox(height: 20,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/5,
              decoration:  const BoxDecoration(
                color:   Color(0xffDEEEFA),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
              ),
              child:  TextFormField(
                controller: tobePaidController,
                keyboardType:TextInputType.number,
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
                  hintText: "Enter Amount",
                  hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
                ),
              ),
              // child: DropdownButtonFormField<String>(
              //   decoration: InputDecoration(
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(
              //         color: Colors.transparent,
              //       ),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(
              //         color: Colors.transparent,
              //       ),
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              //   value: dropdownValue,
              //   items: <String>['Madhya Pradesh', 'Chandigarh', 'UP',].map<DropdownMenuItem<String>>((String value) {
              //     return DropdownMenuItem<String>(
              //       value: value,
              //       child: Text(
              //         value,
              //         style:const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
              //       ),
              //     );
              //   }).toList(),
              //   // Step 5.
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       dropdownValue = newValue!;
              //     });
              //   },
              // ),

            ),
            SizedBox(height: 30,),
            Text('Select Ticket',style: TextStyle(color: Colors.black,fontSize: 18),),
            SizedBox(height: 20,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/5,
              decoration:  const BoxDecoration(
                color:   Color(0xffDEEEFA),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
              ),
              child:   DropdownButton(

                // Initial Value
                value: selectedValue,
                isExpanded: true,
                hint: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text("Select Ticket",style: TextStyle(color: primaryColor),),
                ),
                autofocus: false,
                icon: const Icon(Icons.keyboard_arrow_down),
                // Array list of items
                items: selectTicket?.data!.map((items) {
                  return DropdownMenuItem(
                    value: '${items.id.toString()} '+', ${items.taskId.toString()}',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(items.ticket.toString()),
                    ),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (  newValue) {
                  setState(() {
                    selectedValue = newValue!;
                    print('____________$newValue');
                    print("$selectedValue");
                  });
                },
              ),
            ),
            SizedBox(height: 30,),
            GestureDetector(
              onTap: (){
                setState(() {
                  isLoading = false;
                });
                if(customerAmountController.text.isEmpty && selfAmountController.text.isEmpty && tobePaidController.text.isEmpty){
                  Fluttertoast.showToast(msg: "All fields are required");
                  setState(() {
                    isLoading = false;
                  });
                }
                else if(customerInvoice == null && selfInvoice!.path.isEmpty){
                  Fluttertoast.showToast(msg: "Image is required");
                }else{
                  sendPaymentRequest();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 1.0,
                height: 52,
                alignment: Alignment.center,
                //padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: isLoading ?
                Center(
                  child: Container(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                )
                    : Text("Save", style: buttonTextStyle,),

              ),
            ),

          ],),
      ),
    );
  }
}
