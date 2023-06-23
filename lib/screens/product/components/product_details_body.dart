import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;

import '../../../api_services/api_path.dart';
import '../../../custom_widget/tockenstring.dart';
import '../../../models/getProductModel.dart';

class ProductDetailsBody extends StatefulWidget {
  const ProductDetailsBody({Key? key}) : super(key: key);

  @override
  State<ProductDetailsBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ProductDetailsBody> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return getMyProduct == null ? const Center(child: CircularProgressIndicator(
      semanticsLabel: 'Circular progress indicator',
    ),) : Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 15),
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
            const SizedBox(height: 30,),
            const Text("Product Image :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getMyProduct!.data!.first.productImage}",),
            const SizedBox(height: 30,),
            const Text("Product Invoice :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getMyProduct!.data!.first.productInvoice}",),
            const SizedBox(height: 30,),
            const Text("Warranty Card :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            Image.network("https://cubixsys.com/cubixsys-support/${getMyProduct!.data!.first.warrantyCard}",),
            const SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Purchase Date :${getMyProduct!.data!.first.purchasedDate}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                Text("Invoice Date :${getMyProduct!.data!.first.invoiceDate}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
              ],
            ),
            const SizedBox(height: 20,),
            Text("Warranty Date :${getMyProduct!.data!.first.warrantyDate}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
            const SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: 40,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: Text("Close",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),)),
              ),
            )
          ],),
      ),
    );
  }
}
