import 'dart:async';
import 'package:flutter/material.dart';
import 'package:support_app/screens/login/login.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {



  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration(seconds:4),(){

        Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));


    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image:DecorationImage(
                    image:AssetImage('assets/splashbg.png'),
                    fit: BoxFit.fill
                ),
            ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/splashlogo.png",height: 100,),
          ),
        ),
      ),
    );
  }
}
