import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/screens/dashboard/dashboard.dart';

import '../../../api_services/api_path.dart';
import '../../../classes/size_config.dart';
import 'package:http/http.dart'as http;

import '../../../custom_widget/tockenstring.dart';
import '../../../models/cities_model.dart';
import '../../../models/getProductModel.dart';
import '../../../models/state_model.dart';
import '../../../utils/colour.dart';

class AddTicketsBody extends StatefulWidget {
  const AddTicketsBody({Key? key}) : super(key: key);

  @override
  State<AddTicketsBody> createState() => _TicketsBodyState();
}

class _TicketsBodyState extends State<AddTicketsBody> {

  TextEditingController productNameController = TextEditingController();
  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedValue = null;
  final _dropdownFormKey = GlobalKey<FormState>();
  var dropdownItems = [
    'Support',
    'Wash Basin',
    'Watter Tank'
  ];

  String? dropdownValue;
  int _value = 1;

  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
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

  File? invoiceImageFile;
  _getInvoiceFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        invoiceImageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getInvoiceFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        invoiceImageFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  File? warrantyCardFile;
  _getWarrantyCardFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        warrantyCardFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getWarrantyCardFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        warrantyCardFile = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  File? issueImage;
  _getIssueFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        issueImage = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }
  _getIssueFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        issueImage = File(pickedFile.path);
      });
      Navigator.pop(context);
    }
  }

  DateTime selectedDateInvoice = DateTime.now();

  Future<void> _selectDateInvoice(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateInvoice,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateInvoice) {
      setState(() {
        selectedDateInvoice = picked;
      });
    }
  }
  DateTime selectedDateWarranty = DateTime.now();

  Future<void> _selectDateWarranty(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateWarranty,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateWarranty) {
      setState(() {
        selectedDateWarranty = picked;
      });
    }
  }
  DateTime selectedDatePurchase = DateTime.now();

  Future<void> _selectDatePurchase(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDatePurchase,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDatePurchase) {
      setState(() {
        selectedDatePurchase = picked;
      });
    }
  }


  addProduct() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}create-product'));
    request.fields.addAll({
      'id': '$userId',
      'product_name': productNameController.text,
      'invoice_no': invoiceNumberController.text,
      'invoice_date': '$selectedDateInvoice',
      'purchased_date': '$selectedDatePurchase',
      'warranty_date': '$selectedDateWarranty',
      'ticket': '#64885D5D6A50B',
      'description': descriptionController.text,
      'city': selectCity,
      'state': selectState,
      'address':addressController.text,
      'ticket_type':'0',

    });
    productImageFile == null ? null : request.files.add(await http.MultipartFile.fromPath('product_image', productImageFile!.path.toString()));
    invoiceImageFile == null ? null : request.files.add(await http.MultipartFile.fromPath('product_invoice', invoiceImageFile!.path.toString()));
    warrantyCardFile == null ? null : request.files.add(await http.MultipartFile.fromPath('warranty_card', warrantyCardFile!.path.toString()));
    issueImage == null ? null : request.files.add(await http.MultipartFile.fromPath('image', issueImage!.path.toString()));


    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("_____________this is json rseponse ${jsonResponse}");
      if(jsonResponse['status'] == 1){

        Navigator.pushNamed(context, Dashboard.routeName);

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








  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      print("finala response here ${jsonResponse.message}");
      print("_________________${stateModel?.data?.first.name}");
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString(stateid, 'id');
      print("________________$stateid");
      getCities();
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

    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}city'));
    request.fields.addAll({
      'state': '$selectState'
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
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            SizedBox(height: 10,),
            Text('Product Name',style: TextStyle(color: Colors.black,fontSize: 20),),
            SizedBox(height: 10,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/5,
              decoration: BoxDecoration(
                color:Color(0xffDEEEFA),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
              ),

              child:  TextFormField(
                controller: productNameController,
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
                  hintText: "Enter Product Name",
                  hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),

                ),
              ),

            ),
            SizedBox(height: 20,),
            Text('Invoice Number',style: TextStyle(color: Colors.black,fontSize: 20),),
            SizedBox(height: 10,),
            Container(
              height: 60,
              width: SizeConfig.screenWidth*7/5,
              decoration: BoxDecoration(
                color:Color(0xffDEEEFA),
                borderRadius:  BorderRadius.all(Radius.circular(15)),
              ),

              child:  TextFormField(
                controller: invoiceNumberController,
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
                  hintText: "Enter Product Name",
                  hintStyle:  const TextStyle(color: Color(0xff376AA9), fontWeight: FontWeight.w400, fontSize: 18),

                ),
              ),

            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Invoice Date ',style: TextStyle(color: Colors.black,fontSize: 20),),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        _selectDateInvoice(context);
                      },
                      child: Container(
                        height: 60,
                        width: SizeConfig.screenWidth*7/24,
                        decoration: BoxDecoration(
                          color:Color(0xffDEEEFA),
                          borderRadius:  BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 15),
                          child: Text("${selectedDateInvoice.toLocal()}".split(' ')[0],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        ),


                      ),
                    ),

                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Warranty Date ',style: TextStyle(color: Colors.black,fontSize: 20),),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        _selectDateWarranty(context);
                      },
                      child: Container(
                        height: 60,
                        width: SizeConfig.screenWidth*7/24,
                        decoration: BoxDecoration(
                          color:Color(0xffDEEEFA),
                          borderRadius:  BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 15),
                          child: Text("${selectedDateWarranty.toLocal()}".split(' ')[0],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ),

                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Purchased date ',style: TextStyle(color: Colors.black,fontSize: 20),),
                    SizedBox(height: 20,),
                    InkWell(
                      onTap: (){
                        _selectDatePurchase(context);
                      },
                      child: Container(
                        height: 60,
                        width: SizeConfig.screenWidth*7/24,
                        decoration: BoxDecoration(
                          color:Color(0xffDEEEFA),
                          borderRadius:  BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 15),
                          child: Text("${selectedDatePurchase.toLocal()}".split(' ')[0],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                        ),


                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text('Product Image',style: TextStyle(color: Colors.black,fontSize: 20),),
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
                    width: 130,
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

              ],),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invoice',style: TextStyle(color: Colors.black,fontSize: 20),),
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
                                      _getInvoiceFromCamera();
                                    },
                                  ),
                                  ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                                    title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: (){
                                      _getInvoiceFromGallery();
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
                      width: 130,
                      height: 100,
                      decoration: BoxDecoration(
                        color:Color(0xffDEEEFA), borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: invoiceImageFile == null || invoiceImageFile!.path.isEmpty ?Center(child: Icon(Icons.upload,size: 40,)) : Image.file(invoiceImageFile!,height: 100,fit: BoxFit.fill,)
                      ),
                    ),
                  ),

                ],),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(' Warranty Cart',style: TextStyle(color: Colors.black,fontSize: 20),),
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
                                      _getWarrantyCardFromCamera();
                                    },
                                  ),
                                  ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                                    title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: (){
                                      _getWarrantyCardFromGallery();
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
                      width: 130,height: 100,
                      decoration: BoxDecoration(
                        color:Color(0xffDEEEFA), borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: warrantyCardFile == null || warrantyCardFile!.path.isEmpty ?Center(child: Icon(Icons.upload,size: 40,)) : Image.file(warrantyCardFile!,height: 100,fit: BoxFit.fill,)
                      ),
                    ),
                  ),


                ],),
            ],),
            SizedBox(height: 50,),
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
                                _getIssueFromCamera();
                              },
                            ),
                            ListTile(leading: Image.asset('assets/icons/galeryicon.png', scale: 1.5,),
                              title: Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold)),
                              onTap: (){
                                _getIssueFromGallery();
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
                    child: issueImage == null || issueImage!.path.isEmpty ?Center(child: Icon(Icons.upload,size: 40,)) : Image.file(issueImage!,height: 100,fit: BoxFit.fill,)
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
                  isLoading = true;
                });
                if(productNameController.text.isEmpty && invoiceNumberController.text.isEmpty ){
                  Fluttertoast.showToast(msg: "All fields are required");
                  setState(() {
                    isLoading = false;
                  });
                }
                else if(productImageFile == null && invoiceImageFile == null && warrantyCardFile == null){
                  Fluttertoast.showToast(msg: "All Documents are required");
                }else{
                  addProduct();

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
                    : Text("Generate Ticket", style: buttonTextStyle,),

              ),
            ),

          ],
        ),
      ),
    );
  }

}

