
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:support_app/screens/eCatalogue/ECatalogue.dart';
import 'package:support_app/screens/history/new_tickets.dart';
import 'package:support_app/screens/product/product.dart';
import 'package:support_app/screens/profile/profile.dart';
import 'package:support_app/screens/stores/stores.dart';
import 'package:support_app/screens/tickets/new_ticket.dart';
import 'package:support_app/utils/colour.dart';
import '../api_services/api_path.dart';
import '../custom_widget/tockenstring.dart';
import '../models/getprofile_model.dart';
import '../screens/dashboard/dashboard.dart';
import '../screens/login/login.dart';
import 'package:http/http.dart'as http;


class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key}) : super(key: key);
  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

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
  deleteAccount() async {
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? userId =  prefs.getString(TokenString.userid);

    print("${userId}");
    var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}accountDelete'));
    request.fields.addAll({
      'id': '$userId'
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print('This is api response');
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      Fluttertoast.showToast(msg: '${jsonResponse['message']}');
      Navigator.pushNamedAndRemoveUntil(context, Login.routeName, (route) => false);
    }
    else {
    print(response.reasonPhrase);
    }

  }
  Future<bool> showExitPopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to LogOut an App?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          ElevatedButton(
            onPressed: (){
              Navigator.pushNamedAndRemoveUntil(context, Login.routeName, (route) => false);

            },
            //return true when click on "Yes"
            child:Text('Yes'),
          ),
        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }
  Future<bool> showAccountDeletePopup() async {
    return await showDialog( //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Do you want to Delete Your Account?'),
        actions:[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            //return false when click on "NO"
            child:Text('No'),
          ),

          ElevatedButton(
            onPressed: (){
              deleteAccount();

            },
            //return true when click on "Yes"
            child:Text('Yes'),
          ),
        ],
      ),
    )??false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) => Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children:[
          const SizedBox(height: 40,),
          getProfiledata == null || getProfiledata!.data!.name!.isEmpty &&getProfiledata!.data!.mobile!.isEmpty ?const Center(child: CircularProgressIndicator(
            semanticsLabel: 'Circular progress indicator',
          ),) :Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 20.0, bottom:10.0),
            child: Row(
              children:  [
                getProfiledata!.data!.picture == null ?  Container(
                  height : 60,
                    width: 60,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(Icons.person)):CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: Image.network(
                      'https://cubixsys.com/cubixsys-support/${getProfiledata!.data!.picture}',fit: BoxFit.fill,width: 100,
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    SizedBox(
                      width: 105,
                        child: Text("${getProfiledata!.data!.name} ", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff376AA9),fontSize: 18),overflow: TextOverflow.ellipsis,)),
                    Padding(
                      padding: EdgeInsets.only(left: 0.0, top: 5.0, ),
                      child: Text("${getProfiledata!.data!.mobile}", style: TextStyle(fontWeight: FontWeight.bold,),),
                    ),
                  ],
                ),
                const SizedBox(width: 10,),
                InkWell(
                  onTap: (){ Navigator.pushNamed(context, Profile.routeName); },
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        boxShadow: [
                          BoxShadow(color: Colors.black38, blurRadius: 1.0),
                        ]
                      ),

                      child: const Icon(
                        Icons.edit,
                        color:  Color(0xff376AA9),
                        size: 20,
                      ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30,),
          const Divider(height: 2, thickness: 1, color: Colors.black12,),
          ListTile(leading: const Icon(Icons.home,size: 35,color: Color(0xff376AA9),),title: const Text("Dashboard",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Color(0xff376AA9)),), onTap: () => { Navigator.pushNamed(context, Dashboard.routeName), },),
          const SizedBox(height: 15,),
          // const Divider(height: 2, thickness: 1, color: Colors.black12,),
          ListTile(leading: const Icon(Icons.list,size: 35,),  title: const Text("My Products",style: TextStyle(fontSize: 18),), onTap: () => { Navigator.pushNamed(context, Product.routeName), },),
          // const Divider(height: 2, thickness: 1, color: Colors.black12,),
          const SizedBox(height: 15,),
          ListTile(leading: const Icon(Icons.airplane_ticket,size: 35,), title: const Text("Ticket List",style: TextStyle(fontSize: 18),), onTap: () => { Navigator.pushNamed(context, Ticket.routeName), },),
          // const Divider(height: 2, thickness: 1, color: Colors.black12,),
          const SizedBox(height: 15,),
          ListTile(leading: const Icon(Icons.category,size: 35,),  title: const Text("eCatalogues",style: TextStyle(fontSize: 18),), onTap: () => { Navigator.pushNamed(context, ECatalogue.routeName), },),
          // const Divider(height: 2, thickness: 1, color: Colors.black12,),
          const SizedBox(height: 15,),
          ListTile(leading: const Icon(Icons.store,size: 35,),  title: const Text("Stores",style: TextStyle(fontSize: 18),), onTap: () => { Navigator.pushNamed(context, Stores.routeName), },),
          // const Divider(height: 2, thickness: 1, color: Colors.black12,),
          // const SizedBox(height: 15,),
          // ListTile(leading: const Icon(Icons.history,size: 35,),  title: const Text("Service History",style: TextStyle(fontSize: 18),), onTap: () => { Navigator.pushNamed(context, History.routeName), },),
          // const Divider(height: 2, thickness: 1, color: Colors.black12,),
          const SizedBox(height: 15,),
          ListTile(leading: const Icon(Icons.delete,size: 35,),  title: const Text("Delete Account",style: TextStyle(fontSize: 18),), onTap: () => {
            showAccountDeletePopup(),
  },),
          // const Divider(height: 2, thickness: 1, color: Colors.black12,),
          const SizedBox(height: 15,),
          ListTile(leading: const Icon(Icons.logout,size: 35,),  title: const Text("Logout",style: TextStyle(fontSize: 18),), onTap: () => {
            showExitPopup(),

             },),
          // const Divider(height: 2, thickness: 1, color: Colors.black12,),
        ],
      ),
    );
}
