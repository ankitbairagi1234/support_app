import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'package:support_app/screens/login/login.dart';

import '../../../api_services/api_path.dart';
import '../../../custom_widget/customTextButton.dart';
import '../../../custom_widget/passwordTextField.dart';
import '../../../custom_widget/tockenstring.dart';
import '../../../utils/colour.dart';



class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({Key? key}) : super(key: key);

  @override
  State<NewPasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<NewPasswordScreen> {


  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController  = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool changePasswordStatus  = false;

  bool showOldPassword = false;

  changePassword()async{
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");

    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}updatePassword?old_password'));
    request.fields.addAll({
      'new_password': newPasswordController.text,
      'confirm_password': confirmPasswordController.text,
      'id': '$userId'
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);

        if(jsonResponse['status'] == 1){
          Fluttertoast.showToast(msg: '${jsonResponse['message']}');
          Navigator.pushNamed(context, Login.routeName);

        }
        else{
          setState(() {
            // isLoading = false;
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
    final size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(

        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new,size: 30,),
        ),
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text('Change Password'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        width: size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topRight: Radius.circular(70))
        ),
        //padding: EdgeInsets.symmetric(vertical: 30),
        child: ListView(
          children: [
            SizedBox(height: 40,),
            // CustomTextFormField(label: "Mobile",hint: "",fieldcontroller: mobileController,length: 10,),
            // PasswordTextField(label: 'Old Password', labelColor: greyColor3,fieldController: oldPasswordController,isObscured:showOldPassword == true ? false : true,suffixIcons: InkWell(
            //     onTap: (){
            //       setState(() {
            //         showOldPassword = !showOldPassword;
            //       });
            //     },
            //     child: Icon(changePasswordStatus == true ? Icons.visibility : Icons.visibility_off ))),
            PasswordTextField(label: 'New Password', labelColor: greyColor3,fieldController: newPasswordController,isObscured:changePasswordStatus == true ? false : true,suffixIcons: InkWell(
                onTap: (){
                  setState(() {
                    changePasswordStatus = !changePasswordStatus;
                  });
                },
                child: Icon(changePasswordStatus == true ? Icons.visibility : Icons.visibility_off ))),
            PasswordTextField(label: 'Confirm New Password', labelColor: greyColor3,fieldController: confirmPasswordController,isObscured: changePasswordStatus == true ? false:true,suffixIcons: InkWell(
                onTap: (){
                  setState(() {
                    changePasswordStatus = !changePasswordStatus;
                  });
                },
                child:  Icon(changePasswordStatus == true ? Icons.visibility : Icons.visibility_off )
            ),),
            SizedBox(height: 40,),
            CustomTextButton(buttonText: "Update", onTap: (){
          if(newPasswordController.text !=  confirmPasswordController.text){
                var snackBar = SnackBar(
                  backgroundColor: primaryColor,
                  content: const Text('Both password does not match'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else if(newPasswordController.text.isEmpty){
                var snackBar = SnackBar(
                  backgroundColor: primaryColor,
                  content: Text('Password is required'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else{
                changePassword();
              }
            },)
          ],
        ),
      ),
    ));
  }
}
