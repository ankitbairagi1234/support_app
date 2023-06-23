import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';

import '../../../api_services/api_path.dart';
import '../../../custom_widget/tockenstring.dart';
import '../../../service_provider/dashbord_service_provider/dashboard.dart';
import '../../../utils/colour.dart';
import '../../dashboard/dashboard.dart';
import '../../forget/forget.dart';
import '../../signup/signup.dart';
import 'package:http/http.dart'as http;

import '../../verify_otp/verify_otp.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  var _value = 'Email';
  bool isEmail = true;
  bool showPassword = false;
  bool isLoading = false;

  // String? id;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailOtpController = TextEditingController();


  emailPasswordLogin() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}login'));
    request.fields.addAll({
      'email': emailController.text,
      'password': passwordController.text
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);

      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');

        String id = "${jsonResponse['data']["id"]}";
        String username = "${jsonResponse['data']["name"]}";
        String mobileNo = "${jsonResponse['data']["mobile"]}";

        await prefs.setString(TokenString.userid, id!);
        await prefs.setString(TokenString.userName, username!);
        await prefs.setString(TokenString.userMobile,mobileNo!);


        if(jsonResponse['data']['u_type'] == 2){
          Navigator.pushNamed(context, SpDashboard.routeName);

          Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        }
        else if(jsonResponse['data']['u_type'] == 1){
          Navigator.pushNamed(context, Dashboard.routeName);
          Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        }
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(code:otp,email: emailOtpController.text,)));
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
        padding: const EdgeInsets.only(top: 80.0, left: 35, right: 35),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                const Text("Sign In", style: TextStyle(color: Color(0xff376AA9), fontSize: 35, fontWeight: FontWeight.w500),),
              const SizedBox(height: 35,),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Radio(
                            fillColor: MaterialStateColor.resolveWith(
                                    (states) => primaryColor),
                            activeColor: primaryColor,
                            value: 'Email',
                            groupValue: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = value.toString();
                                isEmail = true;
                              });
                            },
                          ),
                          Text(
                            'Email',
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: isEmail? primaryColor :Colors.black26),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Radio(
                            activeColor: Colors.red,
                            fillColor: MaterialStateColor.resolveWith(
                                    (states) => primaryColor),
                            value: 'Mobile',
                            groupValue: _value,
                            onChanged: (value) {
                              setState(() {
                                _value = value.toString();
                                isEmail = false;
                              });
                            }),
                        Text(
                          'Mobile No.',
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: isEmail? Colors.black12 :primaryColor),
                        ),
                      ],
                    ),
                  )
                ],
              ), //
              SizedBox(height: 30,),
              isEmail? Column(children: [

                SizedBox(height: 20,),
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration:  const BoxDecoration(
                        color: Color(0xffDEEEFA),
                        borderRadius:  BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                      ),
                      child:  const Icon(Icons.email, size: 30, color: Color(0xff376AA9),),

                    ),
                    const SizedBox(width: 5,),
                    Container(
                      height: 60,
                      width: SizeConfig.screenWidth*7/10,
                      decoration:  const BoxDecoration(
                        color:   Color(0xffDEEEFA),
                        borderRadius:  BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                      ),

                      child:  TextFormField(
                        controller: emailController,
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
                          hintText: "Enter your email",
                          hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),

                        ),
                      ),

                    )
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration:  const BoxDecoration(
                        color:   Color(0xffDEEEFA),
                        borderRadius:  BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                      ),
                      child:  const Icon(Icons.lock, size: 30, color: Color(0xff376AA9),),

                    ),
                    const SizedBox(width: 5,),
                    Container(
                      height: 60,
                      width: SizeConfig.screenWidth*7/10,
                      decoration:  const BoxDecoration(
                        color:   Color(0xffDEEEFA),
                        borderRadius:  BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                      ),

                      child:  TextFormField(

                        controller: passwordController,
                        obscureText:showPassword == true ? false : true,
                        keyboardType:TextInputType.emailAddress,
                        decoration:    InputDecoration(
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
                          suffixIcon: InkWell(
                            onTap: (){
                      setState(() {
                      showPassword = !showPassword;
                      });
                      },
                          child: Icon(showPassword == true ? Icons.visibility : Icons.visibility_off,color: primaryColor,)),

                          hintText: "Enter your password",
                          hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:  [
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: InkWell(onTap: (){
                        Navigator.pushNamed(context, Forget.routeName);
                      }, child: const Text("Forget Password?", style: TextStyle(color:  Color(0xff376AA9), fontSize: 15, fontWeight: FontWeight.bold),)),
                    ),
                  ],
                ),

                SizedBox(height: 10,),

                SizedBox(height: 50,),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      isLoading = true;
                    });
                    if(emailController.text.isEmpty && passwordController.text.isEmpty){

                      Fluttertoast.showToast(msg: "All fields are required");
                      setState(() {
                        isLoading = false;
                      });
                    }
                    else{
                      emailPasswordLogin();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
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
                        : Text("Sign In", style: buttonTextStyle,),
                  ),
                )
              ],) :
                  Column(children: [
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration:  const BoxDecoration(
                            color: Color(0xffDEEEFA),
                            borderRadius:  BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                          ),
                          child:  const Icon(Icons.email, size: 30, color: Color(0xff376AA9),),
                        ),
                        const SizedBox(width: 5,),
                        Container(
                          height: 60,
                          width: SizeConfig.screenWidth*7/10,
                          decoration:  const BoxDecoration(
                            color:   Color(0xffDEEEFA),
                            borderRadius:  BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                          ),
                          child:  TextFormField(
                            controller: emailOtpController,
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
                              hintText: "Enter Your Email",
                              hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),

                            ),
                          ),

                        )
                      ],
                    ),
                    const SizedBox(height: 85,),
                    Container(
                      height: 60,
                      width: SizeConfig.screenWidth*7/8.40,
                      decoration:  const BoxDecoration(
                        color:   Color(0xff376AA9),
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
                      ),  child: const Text("Send OTP", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
                    ),
                  ],),
              Container(
                height: SizeConfig.screenHeight*.2,
                color: Colors.transparent,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TextButton(
                  onPressed: () => {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      const Text("Don't have an account? ", style: TextStyle(color: Color(0xff376AA9), fontSize: 18, fontWeight: FontWeight.normal),),
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, Signup.routeName);
                          },
                          child:const  Text("Sign Up", style: TextStyle(color:Color(0xff376AA9), fontSize: 21, fontWeight: FontWeight.bold),),),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
