
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;

import '../forget_verify_otp/verify_forget_password.dart';

class ForgetBody extends StatefulWidget {
  const ForgetBody({Key? key}) : super(key: key);

  @override
  State<ForgetBody> createState() => _ForgetBodyState();
}

class _ForgetBodyState extends State<ForgetBody> {
  bool isLoading = false;


  TextEditingController emailOtpController = TextEditingController();


  String? otp;



  sendOtpLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest('POST', Uri.parse('https://cubixsys.com/cubixsys-support/api/send_otp_email'));
    request.fields.addAll({
      'email': emailOtpController.text
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
          otp = jsonResponse['data'].toString();
          print("___________________${otp}");
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetOtpScreen(code:otp,email: emailOtpController.text,)));
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
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 35, right: 35),
        child: Column(
          children:  [
            Container(
              padding: const EdgeInsets.only(top: 50),
              color: Colors.transparent,
              child: Image.asset('assets/icons/forget_password.png', fit: BoxFit.cover, height: SizeConfig.screenHeight*.3),
            ),
            const SizedBox(height: 30,),
            const Text("Forget Password?", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),),
            const SizedBox(height: 15,),
            const Text("Enter Email associated \nwith your account", textAlign: TextAlign.center, style: TextStyle(color: Color(0xff7B7A7A),  fontSize: 14, fontWeight: FontWeight.w400),),
            const SizedBox(height: 80,),

            TextFormField(
              controller: emailOtpController,
              keyboardType:TextInputType.emailAddress,
              decoration:    InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xffC5C5C5),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color:Color(0xffC5C5C5),
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                hintText: "Enter your email..",
                hintStyle:  const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/8.20,
              decoration:  const BoxDecoration(
                color: Color(0xff376AA9),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
              ),
              child: ElevatedButton(onPressed: (){
                setState(() {
                  isLoading = true;
                });
                if(emailOtpController.text.isEmpty ){

                  Fluttertoast.showToast(msg: "Email Field are required");
                  setState(() {
                    isLoading = false;
                  });
                }
                else{
                  sendOtpLogin();
                }
              }, style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff376AA9)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: Color(0xff376AA9))
                    )
                ),
              ),  child: const Text("Submit", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),

            ),
          ],
        ),
      ),
    );
  }
}
