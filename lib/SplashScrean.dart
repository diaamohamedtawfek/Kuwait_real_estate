import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

import 'BackAndModel/DataResponseSendToken.dart';

class SplashScrean extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UISplash ();
  }

}

class UISplash extends State<SplashScrean> {

  // FirebaseMessaging messaging = FirebaseMessaging.instance;


  // getStringValuesSF() async {
  //   try {
  //     final result = await InternetAddress.lookup('google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       print('connected');
  //
  //       // if(urls!.isNotEmpty){
  //       //   sendToken();
  //       // }
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(type: 1,)));
  //
  //
  //       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNet()));
  //     }
  //   } on SocketException catch (_) {
  //     print('not connected');
  //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNet()));
  //   }
  // }

  // Future<DataResponseSendToken?>? fetckDataFromToken;

  List? urls=[];

  DataResponseSendToken? dataResponseSendToken;
  @override
  void initState() {
    super.initState();
    // * Timer
    // Timer(Duration(seconds: 3),(){getStringValuesSF();});


    getAppInfo();

  }

  getAppInfo() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print(appName);
    print(packageName);
    print(version);
    print(buildNumber);
  }

  // * Send Tokeen
  // sendToken(){
  //   // * Send Token
  //   messaging.getToken().then((token) {
  //     // print("token  >>>>>>>$token");
  //     if (Platform.isIOS) {
  //       Map<String, dynamic> body = {
  //         "apptoken":token,
  //         "appdevice":"ios"
  //       };
  //       fetckDataFromToken = BackEnd.sendToken(body);
  //       fetckDataFromToken!.then((value) => {
  //         // print(value!.allow),
  //         setState(() {
  //           dataResponseSendToken=value;
  //           for(int i =0 ;i<value!.allow!.length;i++){
  //             urls!.add("${value.allow![i]}/");
  //           }
  //           // urls!.add(value!.allow);
  //
  //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => InAppWebViewExampleScreen(dataResponseSendToken: dataResponseSendToken,)));
  //           // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(type: 1,dataResponseSendToken: dataResponseSendToken,)));
  //         })
  //
  //       });
  //     }else{
  //       Map<String, dynamic> body = {
  //         "apptoken":token,
  //         "appdevice":"android"
  //       };
  //       fetckDataFromToken = BackEnd.sendToken(body);
  //       fetckDataFromToken!.then((value) => {
  //         // print(value!.allow),
  //         setState(() {
  //           dataResponseSendToken=value;
  //           for(int i =0 ;i<value!.allow!.length;i++){
  //             setState(() {
  //               urls!.add("${value.allow![i]}/");
  //             });
  //
  //           }
  //
  //           // print("???????"+urls.toString());
  //           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home(type: 1,dataResponseSendToken: dataResponseSendToken,)));
  //         })
  //
  //       });
  //     }
  //
  //   });
  //
  // }
  @override
  Widget build(BuildContext context) {
//    var response = ResponseUI.instance;

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body:

      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

           Center(
             child:  Container(
               height: 300,
               width: 300,
               child: Image.asset('assets/location1.png', fit: BoxFit.cover),
             ),
           ),

          // SizedBox(height: 11,),




          // SizedBox(height: 11,),
          Text("دليل عقارات الكويت",textAlign: TextAlign.center,style: TextStyle(fontSize: 26,color: Color(0xff257AB1),fontWeight: FontWeight.bold),),
          SizedBox(height: 5,),
          Text("www.Q8AQAR.com",textAlign: TextAlign.center,style: TextStyle(fontSize: 22,color: Color(0xffFBC154),fontWeight: FontWeight.bold),),
          SizedBox(height: 16,),
          // Text("انتظر قليلا....",textAlign: TextAlign.center,style: TextStyle(fontSize: 22),),

          Center(
            child: CircularProgressIndicator(color: Colors.black26 ,),
          ),


        ],
      ),

    );
  }
}

