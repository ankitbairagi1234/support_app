
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:support_app/models/cities_model.dart';
import 'package:support_app/screens/dashboard/dashboard.dart';

import '../../../api_services/api_path.dart';
import '../../../models/state_model.dart';
import '../../../utils/colour.dart';
import '../../login/login.dart';
import 'package:http/http.dart'as http;

class SignupBody extends StatefulWidget {
  const SignupBody({Key? key}) : super(key: key);

  @override
  State<SignupBody> createState() => _SignupBodyState();
}

class _SignupBodyState extends State<SignupBody> {

  bool light = false;
  String dropdownValue = 'Select State';
  bool isLoading = false;


  File? adharFile;
  File? dlFile2;
  File? electricFile3;

  var filesPath;
  String? fileName;
  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    setState(() {
      filesPath = result.files.first.path ?? "";
      fileName = result.files.first.name;
      // reportList.add(result.files.first.path.toString());
    });
    var snackBar = SnackBar(
      backgroundColor: primaryColor,
      content: Text('Profile upload successfully'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  var selecteState;
  var selectCity;

  void initState(){
    super.initState();
    getState();
    // getCities();
  }
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  _getAdharFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        adharFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getAdharFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        adharFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getDlFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        dlFile2 = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getDlFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        dlFile2 = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getElectricFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        electricFile3 = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getElectricFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        electricFile3 = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  userRegistration() async {
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}register'));
    request.fields.addAll({
      'name': nameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
      'password': passwordController.text,
      'confirm_password': confirmPasswordController.text
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);

      print("_____________this is json rseponse ${jsonResponse}");
      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');
        print("ooooooookkkkkkkkkkk ${jsonResponse['data']['u_type']}");
        print("this is message ${jsonResponse['message']}");

          Navigator.pushNamed(context, Login.routeName);

          Fluttertoast.showToast(msg: "${jsonResponse['message']}");

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
  serviceProviderRegistration() async {
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}register'));
    request.fields.addAll({
      'name': nameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
      'password': passwordController.text,
      'confirm_password': confirmPasswordController.text,
      'u_type': '2',
      'state': selecteState,
      'city': selectCity,
      'address': addressController.text
    });
    adharFile == null ? null : request.files.add(await http.MultipartFile.fromPath('adhar_card', adharFile!.path.toString()));
    dlFile2 == null ? null : request.files.add(await http.MultipartFile.fromPath('dl_license', dlFile2!.path.toString()));
    electricFile3 == null ? null : request.files.add(await http.MultipartFile.fromPath('el_bill', electricFile3!.path.toString()));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("_____________this is json rseponse ${jsonResponse}");
      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');
        print("ooooooookkkkkkkkkkk ${jsonResponse['data']['u_type']}");
        print("this is message ${jsonResponse['message']}");

        Navigator.pushNamed(context, Login.routeName);

        Fluttertoast.showToast(msg: "${jsonResponse['message']}");

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

  StateModel? stateModel;
  var stateid;

  getState() async {

    var request = http.Request('GET', Uri.parse('${ApiPath.baseUrl}state'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse  = await response.stream.bytesToString();
      final jsonResponse = StateModel.fromJson(json.decode(finalResponse));
      print("finala response here ${jsonResponse.message}");
      print("_________________${stateModel?.data?.first.name}");
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString(stateid, 'id');
      print("________________$stateid");
      setState(() {
        stateModel = jsonResponse;
      });

    }
    else {
    print(response.reasonPhrase);
    }
  }

  CitiesModel? cityModel;
  getCities() async {

    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}api/city'));
    request.fields.addAll({
      'state': '$selecteState'
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse  = await response.stream.bytesToString();
      final jsonResponse = CitiesModel.fromJson(json.decode(finalResponse));
      print("finala response here ${jsonResponse.message}");
      setState(() {
        cityModel = jsonResponse;
      });

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
        padding: const EdgeInsets.only(top: 40.0, left: 35, right: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Sign Up", style: TextStyle(color: Color(0xff376AA9), fontSize: 30, fontWeight: FontWeight.w500),),
            const SizedBox(height: 35,),
            Row(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration:  const BoxDecoration(
                    color: Color(0xffDEEEFA),
                    borderRadius:  BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  ),
                  child:  const Icon(Icons.person, size: 30, color: Color(0xff376AA9),),

                ),
                const SizedBox(width: 5,),
                Container(
                  height: 60,
                  width: SizeConfig.screenWidth*7/10,
                  decoration:const BoxDecoration(
                    color:Color(0xffDEEEFA),
                    borderRadius:  BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
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
                      hintText: "Email ID",
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
                    color: Color(0xffDEEEFA),
                    borderRadius:  BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                  ),
                  child:  const Icon(Icons.phone, size: 30, color: Color(0xff376AA9),),

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
                    controller: mobileController,
                    keyboardType:TextInputType.phone,
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
                      hintText: "Mobile Number",
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
                      hintText: "Password",
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
                    controller: confirmPasswordController,
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
                      hintText: "Confirm Password",
                      hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),
                    ),
                  ),

                )
              ],
            ),

            const SizedBox(height: 2,),
            Row(
              children: [
                Switch(
                  value: light,
                  activeColor: const Color(0xff376AA9),
                  onChanged: (bool value) {
                    setState(() {
                      light = value;
                    });
                  }
                  ),
               const Text("Are you a technician?", style: TextStyle(color: Color(0xff376AA9),  fontSize: 18, fontWeight: FontWeight.w600),)
              ],
            ),
            Visibility(
              visible: light?true:false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration:  const BoxDecoration(
                          color: Color(0xffDEEEFA),
                          borderRadius:  BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                        ),
                        child:  const Icon(Icons.my_location, size: 35, color: Color(0xff376AA9),),

                      ),
                      const SizedBox(width: 5,),
                      Container(
                        height: 60,
                        width: SizeConfig.screenWidth*7/10,
                        decoration:  const BoxDecoration(
                          color:   Color(0xffDEEEFA),
                          borderRadius:  BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                        ),
                        child:   DropdownButton(
                        // Initial Value
                        value: selecteState,
                        isExpanded: true,
                        hint: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text("Select State",style: TextStyle(color: primaryColor),),
                        ),
                        autofocus: false,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        // Array list of items
                        items: stateModel?.data!.map((items) {
                          return DropdownMenuItem(
                            value: items.id.toString(),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(items.name.toString()),
                            ),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (  newValue) {
                          setState(() {
                            selecteState = newValue!;
                            print('$newValue');
                            getCities();

                          });
                        },
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
                        child:  const Icon(Icons.location_on_outlined, size: 35, color: Color(0xff376AA9),),

                      ),
                      const SizedBox(width: 5,),
                      Container(
                        height: 60,
                        width: SizeConfig.screenWidth*7/10,
                        decoration: const BoxDecoration(
                          color:   Color(0xffDEEEFA),
                          borderRadius:  BorderRadius.only(topRight: Radius.circular(15), bottomRight: Radius.circular(15)),
                        ),
                        child:   DropdownButton(
                          // Initial Value
                          value: selectCity,
                          isExpanded: true,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text("Select City",style: TextStyle(color: primaryColor),),
                          ),
                          autofocus: false,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          // Array list of items
                          items: cityModel?.data!.map((items) {
                            return DropdownMenuItem(
                              value: items.id.toString(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                child: Text(items.cityName.toString()),
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (  newValue) {
                            setState(() {
                              selectCity = newValue!;
                              print('$newValue');

                            });
                          },
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
                          color: Color(0xffDEEEFA),
                          borderRadius:  BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
                        ),
                        child:  const Icon(Icons.location_city, size: 35, color: Color(0xff376AA9),),

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
                          controller: addressController,
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
                            hintText: "Address",
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

                      )
                    ],
                  ),
                  const SizedBox(height: 15,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const[
                       Text("All documents required",  style: TextStyle(color: Color(0xff376AA9),  fontSize: 16, fontWeight: FontWeight.w600),),
                    ],
                  ),
                  const SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                          _getAdharFromCamera();
                                        },
                                      ),
                                      ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                                        title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                                        onTap: (){
                                          _getAdharFromGallery();
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
                          height: 50,
                          width: 180,
                          decoration:  BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: adharFile == null || adharFile!.path.isEmpty ?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Adhar Card",style: TextStyle(color: Colors.black45,fontSize: 17),),
                                Icon(Icons.upload)
                              ],
                            ) : Image.file(adharFile!)
                          ),
                        ),
                      ),
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
                                          _getDlFromCamera();
                                        },
                                      ),
                                      ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                                        title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                                        onTap: (){
                                          _getDlFromGallery();
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
                          height: 50,
                          width: 180,
                          decoration:  BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: dlFile2 == null || dlFile2!.path.isEmpty ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("DL License",style: TextStyle(color: Colors.black45,fontSize: 17),),
                                Icon(Icons.upload)
                              ],
                            ): Image.file(dlFile2!)
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                          _getElectricFromCamera();
                                        },
                                      ),
                                      ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                                        title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                                        onTap: (){
                                          _getElectricFromGallery();
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
                          height: 50,
                          width: 180,
                          decoration:  BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: electricFile3 == null || electricFile3!.path.isEmpty ?Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text("Electric bill",style: TextStyle(color: Colors.black45,fontSize: 17),),
                                Icon(Icons.upload)
                              ],
                            ): Image.file(electricFile3!)
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 55,),
                  // This Is used onley Service provider SignUp

                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isLoading = true;
                      });
                      if(emailController.text.isEmpty && passwordController.text.isEmpty&& mobileController.text.isEmpty && nameController.text.isEmpty && confirmPasswordController.text.isEmpty ){
                        Fluttertoast.showToast(msg: "All fields are required");
                        setState(() {
                          isLoading = false;
                        });
                      }
                      else if(adharFile == null && electricFile3 == null && dlFile2 == null ){
                        Fluttertoast.showToast(msg: "All Documents are required");
                      }else{
                        serviceProviderRegistration();

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
                          : Text("Sign Up", style: buttonTextStyle,),

                    ),
                  ),
                  // Container(
                  //   height: 60,
                  //   width: SizeConfig.screenWidth*7/8.40,
                  //   decoration:  const BoxDecoration(
                  //     color:   Color(0xff376AA9),
                  //     borderRadius:  BorderRadius.all(Radius.circular(15)),
                  //   ),
                  //   child: ElevatedButton(onPressed: (){
                  //     Navigator.pushNamed(context, Dashboard.routeName);
                  //   }, style: ButtonStyle(
                  //     backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff376AA9)),
                  //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //         RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(15.0),
                  //             side: const BorderSide(color: Color(0xff376AA9))
                  //         )
                  //     ),
                  //   ),  child: const Text("Sign Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
                  //
                  // )
                ],
              ),
            ),
            const SizedBox(height: 55,),
            // This Is used onley user SignUp
            light ? SizedBox.shrink() :
            GestureDetector(
              onTap: (){
                setState(() {
                  isLoading = true;
                });
                if(emailController.text.isEmpty && passwordController.text.isEmpty&& mobileController.text.isEmpty && nameController.text.isEmpty && confirmPasswordController.text.isEmpty){
                  Fluttertoast.showToast(msg: "All fields are required");
                  setState(() {
                    isLoading = false;
                  });
                }
                else{
                  userRegistration();
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
                    : Text("Sign Up", style: buttonTextStyle,),

              ),
            ),

            // Container(
            //   height: 60,
            //   width: SizeConfig.screenWidth*7/8.40,
            //   decoration:  const BoxDecoration(
            //     color:   Color(0xff376AA9),
            //     borderRadius:  BorderRadius.all(Radius.circular(15)),
            //   ),
            //   child: ElevatedButton(onPressed: (){
            //
            //     Navigator.pushNamed(context, Dashboard.routeName);
            //   }, style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all<Color>(const Color(0xff376AA9)),
            //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //         RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(15.0),
            //             side: const BorderSide(color: Color(0xff376AA9))
            //         )
            //     ),
            //   ),  child: const Text("Sign Up", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),),
            //
            // ) ,

            Container(
              height: SizeConfig.screenHeight*.1,
              color: Colors.transparent,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () => {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text("Already  have an account? ", style: TextStyle(color: Color(0xff376AA9), fontSize: 18, fontWeight: FontWeight.normal),),
                    InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, Login.routeName);
                      },
                      child:const  Text("Sign In", style: TextStyle(color:Color(0xff376AA9), fontSize: 22, fontWeight: FontWeight.w500),),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
