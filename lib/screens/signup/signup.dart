
import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/screens/signup/components/signup_body.dart';

class Signup extends StatelessWidget {
  const Signup({Key? key}) : super(key: key);
  static String routeName = "signup";
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: SizeConfig.screenHeight * 0.15,
         leading: Padding(
           padding: const EdgeInsets.all(8.0),
           child: GestureDetector(
             onTap: (){
               Navigator.pop(context);
             },
               child: const Icon(Icons.arrow_back_ios_new,size: 30,)),
         ),
        title: Padding(
          padding:  EdgeInsets.only(left: SizeConfig.screenWidth*0.2),
        ),
        backgroundColor: const Color(0xff376AA9),
        elevation: 0,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(45),)
        ),
        child: const SignupBody(),
      ),
    );
  }
}
