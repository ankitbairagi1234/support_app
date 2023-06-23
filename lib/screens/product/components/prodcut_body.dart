import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;
import 'package:support_app/screens/product/product_details.dart';

import '../../../api_services/api_path.dart';
import '../../../custom_widget/tockenstring.dart';
import '../../../models/getProductModel.dart';

class ProductBody extends StatefulWidget {
  const ProductBody({Key? key}) : super(key: key);

  @override
  State<ProductBody> createState() => _ProductBodyState();
}

class _ProductBodyState extends State<ProductBody> {

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
    ),) :getMyProduct!.data!.length ==0?Center(child:Text("No data to show",style: TextStyle(fontSize: 20),),) :
    ListView.builder(
      itemBuilder: (context, index){
      int id = index + 1;
      return SingleChildScrollView(
        child: Column(
          children: [
            (id==1)? const SizedBox(height: 40,) :const SizedBox(height:20,),
            InkWell(
              onTap: (){
                int? item = getMyProduct!.data![index].id;
                print('_______this is id$item');
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(item : item)));
                // Navigator.pushNamed(context, ProductDetails.routeName);
              },
              child: Card(
                margin:const EdgeInsets.only(left: 35, right: 35,),
                elevation: 4.0, // adds a shadow to the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // adds rounded corners to the card
                  side:const  BorderSide(
                    color: Colors.transparent, // sets the color of the border
                    width: 0.1, // sets the width of the border
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color:   Color(0xff376AA9),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(9), bottomLeft: Radius.circular(9)),
                      ),
                      width: SizeConfig.containWidth,
                      height: SizeConfig.containHeight,
                      child: Padding(
                        padding: const EdgeInsets.only(top:30.0),
                        child: Text("SN\n$id", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
                      ),
                    ),
                    Container(
                      width: SizeConfig.productImageWidth,
                      height: SizeConfig.productContainHeight,
                      padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                      // color:  Colors.green,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network('https://cubixsys.com/cubixsys-support/${getMyProduct!.data![index].productImage}', fit: BoxFit.cover, height: SizeConfig.productImageHeight, width: SizeConfig.productImageWidth,)),
                    ),
                    SizedBox(
                      width: SizeConfig.productMiddleWidth,
                      child:  ListTile(
                        title: Padding(
                          padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                          child: Text("${getMyProduct!.data![index].productName} ", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20 ), ),
                        ),
                        subtitle: Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text("${getMyProduct!.data![index].purchasedDate}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15 ),),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        int? item = getMyProduct!.data![index].id;
                        print('_______this is id$item');
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(item : item)));
                        // Navigator.pushNamed(context, ProductDetails.routeName);
                      },
                      child: Container(
                        width: SizeConfig.productViewButtonWidth,
                        height: SizeConfig.productViewButtonHeight,
                        decoration: const BoxDecoration(
                          color:   Color(0xff376AA9),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child:  const Padding(
                          padding: EdgeInsets.only(top:7.0, left:18.0),
                          child: Text("View", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }, itemCount: getMyProduct?.data?.length,);
  }
}
