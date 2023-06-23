import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;
import 'package:support_app/screens/dashboard/dashboard.dart';

import '../../../api_services/api_path.dart';
import '../../../custom_widget/tockenstring.dart';
import '../../../models/cities_model.dart';
import '../../../models/getProductModel.dart';
import '../../../models/state_model.dart';
import '../../../utils/colour.dart';

class AddIssueTicketBody extends StatefulWidget {
  const AddIssueTicketBody({Key? key}) : super(key: key);

  @override
  State<AddIssueTicketBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<AddIssueTicketBody> {

  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool isLoading = false;


  // List<GetProductdata>? getproduct;

  GetProductModel? getMyProduct;

  getProduct() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}getProducts'));
    request.fields.addAll({
      'id': '$userId'
    });


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GetProductModel.fromJson(json.decode(finalResponse));


      print("$jsonResponse");
      print("__getprotucts$finalResponse");
      setState(() {
        getMyProduct = jsonResponse;
      });

    }
    else {
      print(response.reasonPhrase);
    }

  }
  File? productImageFile;

  _getProductFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        productImageFile = File(pickedFile.path);
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
        productImageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
    getState();
  }
  StateModel? stateModel;
  var stateid;
  var selectState;
  var selectCity;

  getState() async {

    var request = http.Request('GET', Uri.parse('${ApiPath.baseUrl}state'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var finalResponse  = await response.stream.bytesToString();
      final jsonResponse = StateModel.fromJson(json.decode(finalResponse));
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString(stateid, 'id');
      print("________________$stateid");
      getCities();
      setState(() {
        stateModel = jsonResponse;
        getCities();

      });

    }
    else {
      print(response.reasonPhrase);
    }
  }

  CitiesModel? cityModel;
  getCities() async {

    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}city'));
    request.fields.addAll({
      'state': '$selectState'
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse  = await response.stream.bytesToString();
      final jsonResponse = CitiesModel.fromJson(json.decode(finalResponse));

      setState(() {
        cityModel = jsonResponse;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }

  updateTickets() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}ticketcreate'));
    request.fields.addAll({
      'ticket': '#64885D5D6A50B',
      'description': descriptionController.text,
      'city': selectCity,
      'state': selectState,
      'address':addressController.text,
      'id': '$userId',
      'ticket_type': '0',
      'product_id': '1'
    });
    productImageFile == null ? null : request.files.add(await http.MultipartFile.fromPath('image', productImageFile!.path.toString()));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("_____________this is json rseponse ${jsonResponse}");
      if(jsonResponse['status'] == 1){
        Fluttertoast.showToast(msg: '${jsonResponse['message']}');

        Navigator.pushNamed(context, Dashboard.routeName);

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

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return getMyProduct == null ? const Center(child: CircularProgressIndicator(
      semanticsLabel: 'Circular progress indicator',
    ),) : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Invoice Number :${getMyProduct!.data!.first.invoiceNo}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Text("Product Name :${getMyProduct!.data!.first.productName}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
              ],
            ),
            SizedBox(height: 30,),
            Text("Product Image :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getMyProduct!.data!.first.productImage}",),

            SizedBox(height: 30,),
            Text('Issue Image',style: TextStyle(color: Colors.black,fontSize: 18),),
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
                    child: productImageFile == null || productImageFile!.path.isEmpty ?Center(child: Icon(Icons.upload,size: 40,)) : Image.file(productImageFile!,height: 100,fit: BoxFit.fill,)
                ),
              ),
            ),
            SizedBox(height: 30,),
            Text('Select State',style: TextStyle(color: Colors.black,fontSize: 18),),
            SizedBox(height: 20,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/5,
              decoration:  const BoxDecoration(
                color:   Color(0xffDEEEFA),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
              ),
              child:   DropdownButton(

                // Initial Value
                value: selectState,
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
                    selectState = newValue!;
                    print('____________$newValue');
                    print("$selectState");
                    getCities();
                  });
                },
              ),
            ),
            SizedBox(height: 30,),
            Text('Select City',style: TextStyle(color: Colors.black,fontSize: 18),),
            SizedBox(height: 20,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/5,
              decoration: const BoxDecoration(
                color:   Color(0xffDEEEFA),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
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
                    value: items.cityName.toString(),
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
                    print('$newValue');
                    selectCity = newValue!;
                  });
                },
              ),

            ),
            SizedBox(height: 30,),
            Text('Address',style: TextStyle(color: Colors.black,fontSize: 18),),
            SizedBox(height: 20,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/5,
              decoration:  const BoxDecoration(
                color:   Color(0xffDEEEFA),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
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

            ),
            SizedBox(height: 30,),
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
            GestureDetector(
              onTap: (){
                setState(() {
                  isLoading = false;
                });
                if(addressController.text.isEmpty && descriptionController.text.isEmpty ){
                  Fluttertoast.showToast(msg: "All fields are required");
                  setState(() {
                    isLoading = false;
                  });
                }
                else if(productImageFile == null){
                  Fluttertoast.showToast(msg: "Image is requred");
                }else{
                  updateTickets();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width / 1.0,
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
                    : Text("Save", style: buttonTextStyle,),

              ),
            ),
            // InkWell(
            //     onTap: (){
            //       setState(() {
            //         isLoading = true;
            //       });
            //       if(descriptionController.text.isEmpty &&   addressController.text.isEmpty ){
            //         Fluttertoast.showToast(msg: "All fields are required");
            //         setState(() {
            //           isLoading = false;
            //         });
            //       }
            //       else if(productImageFile == null ){
            //         Fluttertoast.showToast(msg: "Pease Select Issue Image");
            //       }else{
            //         updateTickets();
            //       }
            //     },
            //
            //
            //   child: Container(
            //     height: 40,
            //     width: 90,
            //     decoration: BoxDecoration(
            //       color: primaryColor,
            //       borderRadius: BorderRadius.circular(10),
            //     ),
            //     child: Center(child: Text("Save",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
            //   ),
            // )

          ],),
      ),
    );
  }
}
