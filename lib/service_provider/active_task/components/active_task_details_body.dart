import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;

import '../../../api_services/api_path.dart';
import '../../../custom_widget/tockenstring.dart';
import '../../../models/all_task_details_model.dart';
import '../../../utils/colour.dart';
import '../../dashbord_service_provider/dashboard.dart';

class ActiveTaskDetailsBody extends StatefulWidget {
  const ActiveTaskDetailsBody({Key? key}) : super(key: key);

  @override
  State<ActiveTaskDetailsBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ActiveTaskDetailsBody> {

  TextEditingController titleController = TextEditingController();
  TextEditingController resonController = TextEditingController();
  TextEditingController workDoneTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;



  OtpFieldController controller  =  OtpFieldController();
  FocusNode focusNode = FocusNode();
  String? enteredOtp;
  var focusedBorderColor = primaryColor;
  var fillColor =  greyColor1;
  var borderColor = greyColor2;


  File? addIssueImage;

  _getProductFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        addIssueImage = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getProductFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        addIssueImage = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  File? workDoneImage;

  _workDoneFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        workDoneImage = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _workDoneFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        workDoneImage = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  AllTaskDetails? getActiveDetails;

  taskDetails() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}techticketDetails'));
    request.fields.addAll({
      'ticket_id':'20',
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = AllTaskDetails.fromJson(json.decode(finalResponse));

      print("$jsonResponse");
      print("__task-details$finalResponse");
      setState(() {
        getActiveDetails = jsonResponse;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }
  acceptTask() async {
    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/taskStatus'));
    request.fields.addAll({
      'task_id': '11',
      'status': '1'
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');
        Navigator.pushNamed(context, SpDashboard.routeName);
      }
      else{
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }
  rejectTAsk() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");

    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/taskStatus'));
    request.fields.addAll({
      'task_id': '9',
      'status': '2',
      'title': titleController.text,
      'reason': resonController.text,
      'ticket_id': '9',
      'id': '$userId'
    });
    addIssueImage == null ? null : request.files.add(await http.MultipartFile.fromPath('image', addIssueImage!.path.toString()));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);

      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');
        Navigator.pushNamed(context, SpDashboard.routeName);

      }
      else{
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  doneWorkApi() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/taskStatus'));
    request.fields.addAll({
      'task_id': '9',
      'status': '3',
      'title': workDoneTitleController.text,
      'reason': descriptionController.text,
      'ticket_id': '9',
      'id': '$userId',
      'otp': '$enteredOtp'
    });
    workDoneImage == null ? null : request.files.add(await http.MultipartFile.fromPath('image', workDoneImage!.path.toString()));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');
        Navigator.pushNamed(context, SpDashboard.routeName);
      }
      else{
        Fluttertoast.showToast(msg: "Invalid Otp");
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
    taskDetails();

  }

  String? otp;

  sendOTP() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();

    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/send_otp'));
    request.fields.addAll({
      'ticket_id': '9'
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);

      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');

        String otp = "${jsonResponse['data']}";
        await prefs.setString(TokenString.otp, otp!);
        print(otp);
        otp = otp;
      }
      else{
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirm Reject'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Issue Image',style: TextStyle(color: Colors.black,fontSize: 18),),
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
                                      _getProductFromCamera();
                                    },
                                  ),
                                  ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                                    title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: (){
                                      _getProductFromGallery();
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
                          child: addIssueImage == null || addIssueImage!.path.isEmpty ?Center(child: Icon(Icons.upload,size: 40,)) : Image.file(addIssueImage!,height: 100,fit: BoxFit.fill,)
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),


                  const Text('title',style: TextStyle(color: Colors.black,fontSize: 18),),
                  SizedBox(height: 20,),
                  Container(
                    height: 60,
                    width: SizeConfig.screenWidth*7/5,
                    decoration:  const BoxDecoration(
                      color:   Color(0xffDEEEFA),
                      borderRadius:  BorderRadius.all(Radius.circular(15)),
                    ),
                    child:  TextFormField(
                      controller: titleController,
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
                        hintText: "Title",
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
                  Text('Reson',style: TextStyle(color: Colors.black,fontSize: 18),),
                  SizedBox(height: 20,),
                  Container(
                    height: 80,
                    width: SizeConfig.screenWidth*7/5,
                    decoration:  const BoxDecoration(
                      color:   Color(0xffDEEEFA),
                      borderRadius:  BorderRadius.all(Radius.circular(15)),
                    ),
                    child:  TextFormField(
                      controller: resonController,
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
                          if(titleController.text.isEmpty && resonController.text.isEmpty ){
                            Fluttertoast.showToast(msg: "All fields are required");
                            setState(() {
                              isLoading = false;
                            });
                          }
                          else if(addIssueImage == null){
                            Fluttertoast.showToast(msg: "Image is requred");
                          }else{
                            rejectTAsk();
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
                          child: Center(child: Text("Send",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                        ),
                      ),
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
                          child: Center(child: Text("Close",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                        ),
                      ),

                    ],
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     setState(() {
                  //       isLoading = false;
                  //     });
                  //     if(addressController.text.isEmpty && descriptionController.text.isEmpty ){
                  //       Fluttertoast.showToast(msg: "All fields are required");
                  //       setState(() {
                  //         isLoading = false;
                  //       });
                  //     }
                  //     else if(productImageFile == null){
                  //       Fluttertoast.showToast(msg: "Image is requred");
                  //     }else{
                  //       updateTickets();
                  //     }
                  //   },
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width / 1.0,
                  //     height: 52,
                  //     alignment: Alignment.center,
                  //     //padding: EdgeInsets.all(6),
                  //     decoration: BoxDecoration(
                  //         color: primaryColor,
                  //         borderRadius: BorderRadius.circular(10)
                  //     ),
                  //     child: isLoading ?
                  //     Center(
                  //       child: Container(
                  //         width: 30,
                  //         height: 30,
                  //         child: CircularProgressIndicator(
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     )
                  //         : Text("Save", style: buttonTextStyle,),
                  //
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
  }
  Future<void> _workDone(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Done Task'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Otp',style: TextStyle(color: Colors.black,fontSize: 18),),
                  const SizedBox(height: 20,),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child:OTPTextField(
                        controller: controller,
                        length: 4,
                        keyboardType: TextInputType.number,
                        width: MediaQuery.of(context).size.width,
                        textFieldAlignment: MainAxisAlignment.spaceEvenly,
                        fieldWidth: 50,
                        contentPadding: EdgeInsets.all(11),
                        fieldStyle: FieldStyle.box,
                        outlineBorderRadius: 15,
                        otpFieldStyle: OtpFieldStyle(
                            backgroundColor: Color(0xffFFFFFF),
                            disabledBorderColor: Colors.white
                        ),
                        style: TextStyle(fontSize: 17, height: 2.2),
                        onChanged: (pin) {
                          print("checking pin here ${pin}");
                        },
                        onCompleted: (pin) {
                          if (pin.isNotEmpty && pin?.length == 4) {
                            setState(() {
                              enteredOtp = pin;
                            });
                          } else {
                          }
                        },
                      )
                    // child: PinCodeTextField(
                    //   controller: controller,
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   appContext: (context),
                    //   onChanged: (value){
                    //
                    //   },
                    //   onSubmitted: ,
                    //   length: 4,
                    //   pinTheme: PinTheme(
                    //       shape: PinCodeFieldShape.box,
                    //       borderRadius: BorderRadius.circular(10),
                    //       activeColor: primaryColor,
                    //       fieldWidth: 48,
                    //       fieldHeight: 48,
                    //       selectedColor:  greyColor,
                    //       borderWidth: 2,
                    //       inactiveColor: Colors.grey
                    //   ),
                    // ),
                  ),
                  // Container(
                  //   height: 60,
                  //   width: SizeConfig.screenWidth*7/5,
                  //   decoration:  const BoxDecoration(
                  //     color:   Color(0xffDEEEFA),
                  //     borderRadius:  BorderRadius.all(Radius.circular(15)),
                  //   ),
                  //   child:  TextFormField(
                  //
                  //     controller: titleController,
                  //     keyboardType:TextInputType.emailAddress,
                  //     decoration: InputDecoration(
                  //       enabledBorder: OutlineInputBorder(
                  //         borderSide: const BorderSide(
                  //           color: Colors.transparent,
                  //         ),
                  //         borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //       focusedBorder: OutlineInputBorder(
                  //         borderSide: const BorderSide(
                  //           color: Colors.transparent,
                  //         ),
                  //         borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //       hintText: "OTP",
                  //       hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
                  //     ),
                  //   ),
                  //   // child: DropdownButtonFormField<String>(
                  //   //   decoration: InputDecoration(
                  //   //     enabledBorder: OutlineInputBorder(
                  //   //       borderSide: const BorderSide(
                  //   //         color: Colors.transparent,
                  //   //       ),
                  //   //       borderRadius: BorderRadius.circular(10.0),
                  //   //     ),
                  //   //     focusedBorder: OutlineInputBorder(
                  //   //       borderSide: const BorderSide(
                  //   //         color: Colors.transparent,
                  //   //       ),
                  //   //       borderRadius: BorderRadius.circular(10.0),
                  //   //     ),
                  //   //   ),
                  //   //   value: dropdownValue,
                  //   //   items: <String>['Madhya Pradesh', 'Chandigarh', 'UP',].map<DropdownMenuItem<String>>((String value) {
                  //   //     return DropdownMenuItem<String>(
                  //   //       value: value,
                  //   //       child: Text(
                  //   //         value,
                  //   //         style:const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
                  //   //       ),
                  //   //     );
                  //   //   }).toList(),
                  //   //   // Step 5.
                  //   //   onChanged: (String? newValue) {
                  //   //     setState(() {
                  //   //       dropdownValue = newValue!;
                  //   //     });
                  //   //   },
                  //   // ),
                  // ),

                  const SizedBox(height: 30,),

                  const Text('title',style: TextStyle(color: Colors.black,fontSize: 18),),
                  SizedBox(height: 20,),
                  Container(
                    height: 60,
                    width: SizeConfig.screenWidth*7/5,
                    decoration:  const BoxDecoration(
                      color:   Color(0xffDEEEFA),
                      borderRadius:  BorderRadius.all(Radius.circular(15)),
                    ),
                    child:  TextFormField(
                      controller: workDoneTitleController,
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
                        hintText: "Title",
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
                  const Text(' Image',style: TextStyle(color: Colors.black,fontSize: 18),),
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
                                      _workDoneFromCamera();
                                    },
                                  ),
                                  ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                                    title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: (){
                                      _workDoneFromGallery();
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
                          child: workDoneImage == null || workDoneImage!.path.isEmpty ?Center(child: Icon(Icons.upload,size: 40,)) : Image.file(workDoneImage!,height: 100,fit: BoxFit.fill,)
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),

                  Text('Description',style: TextStyle(color: Colors.black,fontSize: 18),),
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
                          if(workDoneTitleController.text.isEmpty && descriptionController.text.isEmpty ){
                            Fluttertoast.showToast(msg: "All fields are required");
                            setState(() {
                              isLoading = false;
                            });
                          }
                          else if(workDoneImage == null){
                            Fluttertoast.showToast(msg: "Image is requred");
                          }else{
                            doneWorkApi();
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
                          child: Center(child: Text("Close",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
                        ),
                      ),

                    ],
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     setState(() {
                  //       isLoading = false;
                  //     });
                  //     if(addressController.text.isEmpty && descriptionController.text.isEmpty ){
                  //       Fluttertoast.showToast(msg: "All fields are required");
                  //       setState(() {
                  //         isLoading = false;
                  //       });
                  //     }
                  //     else if(productImageFile == null){
                  //       Fluttertoast.showToast(msg: "Image is requred");
                  //     }else{
                  //       updateTickets();
                  //     }
                  //   },
                  //   child: Container(
                  //     width: MediaQuery.of(context).size.width / 1.0,
                  //     height: 52,
                  //     alignment: Alignment.center,
                  //     //padding: EdgeInsets.all(6),
                  //     decoration: BoxDecoration(
                  //         color: primaryColor,
                  //         borderRadius: BorderRadius.circular(10)
                  //     ),
                  //     child: isLoading ?
                  //     Center(
                  //       child: Container(
                  //         width: 30,
                  //         height: 30,
                  //         child: CircularProgressIndicator(
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     )
                  //         : Text("Save", style: buttonTextStyle,),
                  //
                  //   ),
                  // ),
                ],
              ),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return getActiveDetails == null ? const Center(child: CircularProgressIndicator(
      semanticsLabel: 'Circular progress indicator',
    ),) : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Product Name :${getActiveDetails!.data!.productName}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Text("Product Id :${getActiveDetails!.data!.productId}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
              ],
            ),
            SizedBox(height: 30,),
            Text("Product Image :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getActiveDetails!.data!.productImage}",),
            SizedBox(height: 30,),
            SizedBox(height: 30,),
            Text("Issue Image :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getActiveDetails!.data!.image}",),
            Text("Product Invoice :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getActiveDetails!.data!.productInvoice}",),
            SizedBox(height: 30,),
            Text("Warranty Card :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getActiveDetails!.data!.warrantyCard}",),
            Divider(thickness: 1,color: Colors.black,),

            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Purchase Date :${getActiveDetails!.data!.purchasedDate}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Text("Invoice Date :${getActiveDetails!.data!.invoiceDate}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
              ],
            ),
            Divider(thickness: 1,color: Colors.black,),
            SizedBox(height: 20,),

            Text("Warranty Date :${getActiveDetails!.data!.warrantyDate}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            Divider(thickness: 1,color: Colors.black,),

            SizedBox(height: 20,),
            Text("Description :${getActiveDetails!.data!.description}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            Divider(thickness: 1,color: Colors.black,),

            SizedBox(height: 20,),
            Text("Customer Name :${getActiveDetails!.data!.name}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            Divider(thickness: 1,color: Colors.black,),

            SizedBox(height: 20,),
            Text("Mobile :${getActiveDetails!.data!.mobile}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            Divider(thickness: 1,color: Colors.black,),

            SizedBox(height: 30,),

            Text("Address :${getActiveDetails!.data!.address}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            Divider(thickness: 1,color: Colors.black,),

            SizedBox(height: 30,),
            Text("City :${getActiveDetails!.data!.city}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            Divider(thickness: 1,color: Colors.black,),

            SizedBox(height: 30,),
            Text("State :${getActiveDetails!.data!.state}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            Divider(thickness: 1,color: Colors.black,),

            SizedBox(height: 30,),
            // InkWell(
            //   onTap: (){
            //     sendOTP();
            //     _workDone(context);
            //   },
            //   child: Container(
            //     height: 40,
            //     width: 90,
            //     decoration: BoxDecoration(
            //       color: Colors.green,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: const Center(child: Text("Done",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
            //   ),
            // ),
            // getTotalTaskDetails!.data!.taskStatus == 0?
            // InkWell(
            //   onTap: (){
            //     sendOTP();
            //     _workDone(context);
            //   },
            //   child: Container(
            //     height: 40,
            //     width: 90,
            //     decoration: BoxDecoration(
            //       color: Colors.green,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: const Center(child: Text("Done",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
            //   ),
            // ):  getTotalTaskDetails!.data!.taskStatus == 1?
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     InkWell(
            //       onTap: (){
            //         acceptTask();
            //         // Navigator.pop(context);
            //       },
            //       child: Container(
            //         height: 40,
            //         width: 90,
            //         decoration: BoxDecoration(
            //           color: Colors.green,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: Center(child: Text("Accept",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
            //       ),
            //     ),
            //     InkWell(
            //       onTap: (){
            //         _displayTextInputDialog(context);
            //       },
            //       child: Container(
            //         height: 40,
            //         width: 90,
            //         decoration: BoxDecoration(
            //           color: Colors.red,
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //         child: const Center(child: Text("Reject",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
            //       ),
            //     ),
            //   ],
            // ):  InkWell(
            //   onTap: (){
            //     // Navigator.pop(context);
            //   },
            //   child: Container(
            //     height: 40,
            //     width: 90,
            //     decoration: BoxDecoration(
            //       color: Colors.green,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: const Center(child: Text("Done",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
            //   ),
            // ),
          ],),
      ),
    );
    // ListView.builder(
    //   itemBuilder: (context, index){
    //     int id = index + 1;
    //     return Column(
    //       children: [
    //         (id==1)? const SizedBox(height: 40,) :const SizedBox(height:20,),
    //         Card(
    //           margin:const EdgeInsets.only(left: 35, right: 35),
    //           elevation: 4.0, // adds a shadow to the card
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10.0), // adds rounded corners to the card
    //             side:const  BorderSide(
    //               color: Colors.transparent, // sets the color of the border
    //               width: 0.1, // sets the width of the border
    //             ),
    //           ),
    //
    //           child: Row(
    //             children: [
    //               Container(
    //                 decoration: const BoxDecoration(
    //                   color:   Color(0xff376AA9),
    //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(9), bottomLeft: Radius.circular(9)),
    //                 ),
    //                 width: SizeConfig.containWidth,
    //                 height: SizeConfig.containHeight,
    //
    //                 child: Padding(
    //                   padding: const EdgeInsets.only(top:30.0),
    //                   child: Text("SN\n$id", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
    //                 ),
    //               ),
    //               Container(
    //                 width: SizeConfig.productImageWidth,
    //                 height: SizeConfig.productContainHeight,
    //                 padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
    //                 // color:  Colors.green,
    //                 child: ClipRRect(
    //                     borderRadius: BorderRadius.circular(10),
    //                     child: Image.network('https://cubixsys.com/cubixsys-support/${getMyProduct!.data![index].productImage}', fit: BoxFit.cover, height: SizeConfig.productImageHeight, width: SizeConfig.productImageWidth,)),
    //               ),
    //
    //               SizedBox(
    //                 width: SizeConfig.productMiddleWidth,
    //                 child:  ListTile(
    //                   title: Padding(
    //                     padding: EdgeInsets.only(top:8.0, bottom: 8.0),
    //                     child: Text("${getMyProduct!.data![index].productName} ", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20 ), ),
    //                   ),
    //                   subtitle: Padding(
    //                     padding: EdgeInsets.only(bottom: 8.0),
    //                     child: Text("${getMyProduct!.data![index].purchasedDate}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15 ),),
    //                   ),
    //                 ),
    //               ),
    //
    //               InkWell(
    //                 onTap: (){
    //                   // Navigator.push(context, MaterialPageRoute(builder: (c)=>Productdetails()
    //                   // ));
    //                 },
    //                 child: Container(
    //                   width: SizeConfig.productViewButtonWidth,
    //                   height: SizeConfig.productViewButtonHeight,
    //                   decoration: const BoxDecoration(
    //                     color:   Color(0xff376AA9),
    //                     borderRadius: BorderRadius.all(Radius.circular(5)),
    //                   ),
    //                   child:  const Padding(
    //                     padding: EdgeInsets.only(top:7.0, left:18.0),
    //                     child: Text("View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),),
    //                   ),
    //                 ),
    //               ),
    //
    //
    //             ],
    //           ),
    //         ),
    //       ],
    //     );
    //   }, itemCount: getMyProduct?.data?.length,);
  }
}
