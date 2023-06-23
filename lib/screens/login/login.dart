
import 'package:flutter/material.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/screens/login/components/login_body.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);
  static String routeName =  "/login";
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: const Color(0xff376AA9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: SizeConfig.screenHeight * 0.15,
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
        child: const LoginBody(),
      ),
    );
  }
}
