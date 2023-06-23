import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/changepassword/change_password.dart';
import 'package:support_app/models/getprofile_model.dart';
import 'package:support_app/screens/dashboard/dashboard.dart';

import '../../../api_services/api_path.dart';
import '../../../classes/size_config.dart';
import '../../../custom_widget/tockenstring.dart';
import '../../../utils/colour.dart';
import 'package:http/http.dart'as http;
class SpProfileBody extends StatefulWidget {
  const SpProfileBody({Key? key}) : super(key: key);

  @override
  State<SpProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<SpProfileBody> {

  bool isLoading = false;

  File? profilePhoto;


  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  void initState(){
    super.initState();
    getProfile();
  }


  GetProfile? getProfiledata;

  getProfile() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}getProfile'));
    request.fields.addAll({
      'id': "$userId"
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GetProfile.fromJson(json.decode(finalResponse));

      setState(() {
        getProfiledata = jsonResponse;
        nameController = TextEditingController(text: getProfiledata!.data!.name);
        emailController = TextEditingController(text: getProfiledata!.data!.email);
        mobileController = TextEditingController(text: getProfiledata!.data!.mobile);

      });


    }
    else {
      print(response.reasonPhrase);
    }

  }

  updateProfile() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}updateprofile'));
    request.fields.addAll({
      'id': "$userId",
      'name': nameController.text,
      'mobile': mobileController.text,
    });
    profilePhoto == null ? null : request.files.add(await http.MultipartFile.fromPath('picture', profilePhoto!.path.toString()));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var finalResult =  await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      print("final json response  ${jsonResponse}");
      if(jsonResponse['status'] == 1){

        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        Navigator.pushNamed(context, Dashboard.routeName);


      }
      setState(() {
      });

    }
    else {
      print(response.reasonPhrase);
    }


  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        profilePhoto = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        profilePhoto = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: getProfiledata == null || getProfiledata!.data!.name!.isEmpty ? Center(child: CircularProgressIndicator(
        semanticsLabel: 'Circular progress indicator',
      ),) :Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20,),
          Stack(children: [
            Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: NetworkImage('https://googleflutter.com/sample_image.jpg'),
                      fit: BoxFit.fill
                  ),

                ),
                child:profilePhoto==null || profilePhoto!.path.isEmpty? SizedBox.shrink() : ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(profilePhoto!,fit: BoxFit.fill,))
            ),
            Positioned(
                top: 100,
                left: 90,
                child: InkWell(
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
                                      _getFromCamera();
                                    },
                                  ),
                                  ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                                    title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: (){
                                      _getFromGallery();
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
                    child: Image.asset("assets/icons/cameraicon.png",scale: 1.3,)))

          ],),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
            child: Column(
              children: [
                Container(
                  height: 60,
                  width: SizeConfig.screenWidth*7/5,
                  decoration: BoxDecoration(
                    color:Color(0xffDEEEFA),
                    borderRadius:  BorderRadius.all(Radius.circular(15)),
                  ),

                  child:  TextFormField(
                    controller: nameController,
                    keyboardType:TextInputType.name,
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
                      hintText: "Name",
                      hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),

                    ),
                  ),

                ),
                SizedBox(height: 20,),
                Container(
                  height: 60,
                  width: SizeConfig.screenWidth*7/5,
                  decoration: BoxDecoration(
                    color:Color(0xffDEEEFA),
                    borderRadius:  BorderRadius.all(Radius.circular(15)),
                  ),

                  child:  TextFormField(
                    controller: emailController,
                    keyboardType:TextInputType.name,
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
                      hintText: "Email",
                      hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),

                    ),
                  ),

                ),
                SizedBox(height: 20,),

                Container(
                  height: 60,
                  width: SizeConfig.screenWidth*7/5,
                  decoration: BoxDecoration(
                    color:Color(0xffDEEEFA),
                    borderRadius:  BorderRadius.all(Radius.circular(15)),
                  ),

                  child:  TextFormField(
                    controller: mobileController,
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
                      hintText: "Mobile",
                      hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),

                    ),
                  ),

                ),
                SizedBox(height: 60,),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      // isLoading = true;
                    });
                    if(emailController.text.isEmpty &&  mobileController.text.isEmpty && nameController.text.isEmpty ){
                      Fluttertoast.showToast(msg: "All fields are required");
                      setState(() {
                        isLoading = false;
                      });
                    }
                    else{
                      // userRegistration();
                    }
                  },
                  child: InkWell(
                    onTap: (){
                      updateProfile();
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
                          : Text("Update Profile", style: buttonTextStyle,),

                    ),
                  ),
                ),

                SizedBox(height: 30,),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordScreen()));
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
                        : Text("Change Password", style: buttonTextStyle,),

                  ),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
