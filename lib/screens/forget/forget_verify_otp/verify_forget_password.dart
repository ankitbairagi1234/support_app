import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart'as http;
import 'package:support_app/screens/forget/forget_password_screen/new_password.dart';

import '../../../api_services/api_path.dart';
import '../../../classes/size_config.dart';
import '../../../custom_widget/customTextButton.dart';
import '../../../custom_widget/tockenstring.dart';
import '../../../service_provider/dashbord_service_provider/dashboard.dart';
import '../../../utils/colour.dart';
import '../../dashboard/dashboard.dart';



class ForgetOtpScreen extends StatefulWidget {
  String? code,email;
  ForgetOtpScreen({super.key,this.email,this.code});

  @override
  State<ForgetOtpScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<ForgetOtpScreen> {


  OtpFieldController controller  =  OtpFieldController();
  FocusNode focusNode = FocusNode();
  String? enteredOtp;
  var focusedBorderColor = primaryColor;
  var fillColor =  greyColor1;
  var borderColor = greyColor2;

  bool isLoading = false;


  var newOtp;

  verifyOtpLogin() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/verify_otp'));
    request.fields.addAll({
      'otp': widget.code.toString(),
      'email': widget.email.toString()
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);

      print("${finalResponse}");

      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');

        Navigator.push(context, MaterialPageRoute(builder: (context)=>NewPasswordScreen()));

        // if(jsonResponse['data']['u_type'] == 2){
        //   Navigator.pushNamed(context, SpDashboard.routeName);
        //
        //   Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        // }
        // else if(jsonResponse['data']['u_type'] == 1){
        //   Navigator.pushNamed(context, Dashboard.routeName);
        //   Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        // }
      }
      else{
        setState(() {
          isLoading = false;
        });

        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
      }

    }
    else {
    }
  }


  // resendOtp()async{
  //   SharedPreferences prefs  = await SharedPreferences.getInstance();
  //   String? type = prefs.getString(TokenString.userType);
  //   print("kkkkk ${type}");
  //   var headers = {
  //     'Cookie': 'ci_session=25ff5e4d1c8952f258520edbe7b2b7ec8703cfa9'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}resent_otp/${type}'));
  //   request.fields.addAll({
  //     'mobile': '${widget.mobile}'
  //   });
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     var finalResponse =  await response.stream.bytesToString();
  //     final jsonResponse = json.decode(finalResponse);
  //     print("final json response ${jsonResponse}");
  //     setState(() {
  //       newOtp = jsonResponse['otp'];
  //       print("new otp ${newOtp}");
  //       widget.code = newOtp;
  //     });
  //     print("sdsdsdsds ${widget.code}");
  //     var snackBar = SnackBar(
  //       content: Text('${jsonResponse['message']}'),
  //     );
  //
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: primaryColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          toolbarHeight: SizeConfig.screenHeight * 0.15,
          backgroundColor: const Color(0xff376AA9),

          leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
              // Get.to(SignInScreen());
            },
            child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 26),
          ),
          title:  Text('Verification', style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),),
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topRight: Radius.circular(45),)
          ),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              alignment: Alignment.center,
              width: size.width,
              height: size.height,
              child: Column(
                children: [
                  SizedBox(height: 50,),
                  Text("Code has sent to", style: TextStyle(fontSize: 22, color: primaryColor),),
                  SizedBox(height: 5,),
                  Text("${widget.email}", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),),
                  SizedBox(height: 10,),
                  Text("OTP-${widget.code}"),
                  SizedBox(height: 30,),
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
                            backgroundColor: const Color(0xffFFFFFF),
                            disabledBorderColor: Colors.white
                        ),
                        style: TextStyle(fontSize: 17, height: 2.2),
                        onChanged: (pin) {
                          print("checking pin here ${pin}");
                        },
                        onCompleted: (pin) {
                          if (pin.isNotEmpty && pin.length == 4) {
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
                  // SizedBox(height: 30,child: Text("Haven't received the verification code?", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),),),
                  // InkWell(
                  //     onTap: (){
                  //       // resendOtp();
                  //     },
                  //     child: Text("Resend", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)),
                  SizedBox(height: 90 ,),
                  CustomTextButton(buttonText: "Verify Authentication Code", onTap: (){
                    if(enteredOtp == widget.code){
                      Fluttertoast.showToast(msg: "Otp verified successfully");
                      verifyOtpLogin();
                    }
                    else{
                      Fluttertoast.showToast(msg: "Please enter valid otp");
                    }
                  },),
                ],
              ),
            ),
          ),
        )
    );
  }
}

