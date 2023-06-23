
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:support_app/classes/size_config.dart';
import 'package:http/http.dart'as http;
import 'package:support_app/models/e_catalog_model.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:dio/dio.dart';

import '../../../utils/colour.dart';
class EcatalogueBody extends StatefulWidget {
  const EcatalogueBody({Key? key}) : super(key: key);

  @override
  State<EcatalogueBody> createState() => _EcatalogueBodyState();
}

class _EcatalogueBodyState extends State<EcatalogueBody> {

  eCatalogModel? eCatalog;
  var file;
  eCatalogue() async {
    var request = http.Request('GET', Uri.parse('https://cubixsys.com/cubixsys-support/api/eCatalogue'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = eCatalogModel.fromJson(jsonDecode(finalResponse));

      print("$jsonResponse");
      print("__overprotects$finalResponse");
      setState(() {
        eCatalog = jsonResponse;
      });

    }
    else {
    print(response.reasonPhrase);
    }
  }
  downloadFile(String url, String filename) async {

    FileDownloader.downloadFile(
        url: "${url}",
        name: "Report",
        onDownloadCompleted: (path) {
          final File file = File(path);
          print("path here ${file}");
          var snackBar = SnackBar(
            backgroundColor: primaryColor,
            content: Text('File  Saved in your gallery'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          //This will be the path of the downloaded file
        });

    // if (Platform.isAndroid) {
    //
    //   var status = await Permission.storage.status;
    //   if (status != PermissionStatus.granted) {
    //     status = await Permission.storage.request();
    //   }
    //   if (status.isGranted) {
    //     const downloadsFolderPath = '/storage/emulated/0/Download/';
    //     Directory dir = Directory(downloadsFolderPath);
    //     file = File('${dir.path}');
    //   }
    // }
  }

  Future<bool> saveFile(String url, String fileName) async {
    try {
      {
        Directory? directory;
        directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/PDF_Download";
        directory = Directory(newPath);

        File saveFile = File(directory.path + "/$fileName");
        if (kDebugMode) {
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          await Dio().download(
            url,
            saveFile.path,
          );
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eCatalogue();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return eCatalog == null ? const Center(child: CircularProgressIndicator(
      semanticsLabel: 'Circular progress indicator',
    ),) :eCatalog!.data!.isEmpty?Center(child:Text("No data to show",style: TextStyle(fontSize: 20),),) :
      ListView.builder(itemBuilder: (context, index){
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
                // Container(
                //   width: SizeConfig.productImageWidth,
                //   height: SizeConfig.productContainHeight,
                //   padding: const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                //   // color:  Colors.green,
                //   child: ClipRRect(
                //       borderRadius: BorderRadius.circular(10),
                //       child: Image.network('https://cubixsys.com/cubixsys-support/${eCatalog!.data![index].productCatalogue }', fit: BoxFit.cover, height: SizeConfig.productImageHeight, width: SizeConfig.productImageWidth,)),
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Padding(
                      padding: EdgeInsets.only(top:8.0, bottom: 8.0),
                      child: Text("${eCatalog?.data![index].catalogueName} ", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20 ), ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text("${eCatalog?.data![index].date}", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15 ),),
                    ),
                  ],),
                ),
                const Spacer(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      print('true');
                      // saveFile(eCatalog!.data![index].productCatalogue.toString(), "sample.pdf");
                      downloadFile("https://cubixsys.com/cubixsys-support/${eCatalog!.data![index].productCatalogue.toString()}", "resume.pdf");


                    },
                    child: Container(
                      width: 150,
                      height: SizeConfig.containButtonHeight,
                      decoration: const BoxDecoration(
                        color:   Color(0xff376AA9),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child:  const Center(child: Text("Download/PDF", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500,  fontSize: 15 ),)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }, itemCount: eCatalog?.data?.length,);
  }
}

