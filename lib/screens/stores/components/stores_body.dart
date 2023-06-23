
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import '../../../api_services/api_path.dart';
import '../../../classes/size_config.dart';
import '../../../models/get_store_model.dart';

class StoresBody extends StatefulWidget {
  const StoresBody({Key? key}) : super(key: key);

  @override
  State<StoresBody> createState() => _StoresBodyState();
}

class _StoresBodyState extends State<StoresBody> {

  GetStoreList? getStoreList;

  storeList() async {
    var request = http.Request('GET', Uri.parse('${ApiPath.baseUrl}storeList'));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse  = await response.stream.bytesToString();
      final jsonResponse = GetStoreList.fromJson(json.decode(finalResponse));
      setState(() {
        getStoreList = jsonResponse;
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
    storeList();
  }
  @override
  Widget build(BuildContext context) {
    return getStoreList == null ?const Center(child: CircularProgressIndicator(
      semanticsLabel: 'Circular progress indicator',
    ),) : getStoreList!.data!.length == 0 ? Center(child: const Text("No Store Available",style: TextStyle(fontSize: 20),)) : ListView.builder(itemBuilder: (context, index){
      int id = index + 1;
      return  Column(
        children: [
          (id==1)? const SizedBox(height: 40,) :const SizedBox(height:20,),
          Card(
            margin:const EdgeInsets.only(left: 35, right: 35),
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
                    child: Text("Sn\n$id", textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
                  ),
                ),
                Container(
                  width: SizeConfig.containMiddleWidth,
                  height: SizeConfig.containHeight,
                  color:  Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    ListTile(
                      title: Padding(
                        padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                        child: Text("Store Name: ${getStoreList!.data![index].storeName} ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20 ), ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(bottom: 4.0),
                        child: Text("${getStoreList!.data![index].storeAddress}, ${getStoreList!.data![index].city}, ${getStoreList!.data![index].pinCode}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18   ),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0),
                      child: Text("${getStoreList!.data![index].state}",style: TextStyle(fontSize: 16),),
                    )
                  ],)

                ),

                // Container(
                //   width: SizeConfig.containButtonWidth,
                //   height: SizeConfig.containButtonHeight,
                //   decoration: const BoxDecoration(
                //     color:   Color(0xff376AA9),
                //     borderRadius: BorderRadius.all(Radius.circular(5)),
                //   ),
                //   child:  const Padding(
                //     padding: EdgeInsets.only(top:7.0, left:12.0),
                //     child: Text("Download", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,  fontSize: 15 ),),
                //   ),
                // ),


              ],
            ),
          ),
        ],
      );
    }, itemCount: getStoreList?.data?.length,);
  }
}
