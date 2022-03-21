import 'dart:io';
import 'package:aqarr_elquet/InAppReview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
      AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }


  runApp(MyApp());
}

class EmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
    );
  }

  @override
  Size get preferredSize => Size(0.0, 0.0);
}
class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>***************************");
      print('A new onMessageOpenedApp event was published!   ${message.notification!.title}');
      // try{
      //   setState(() {
      //     applinker="${message.data["linker"]}";
      //     // sendToken(applinker.toString());
      //   });
      // }catch(e){}
      //
      // new Future.delayed(Duration.zero, () {
      //   showDialog(context: context,
      //       builder: (BuildContext context) {
      //         return new Container(child: new Text("${message.data["linker"]}"));
      //       });
      // });
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>***************************");
      // Navigator.pushNamed(context, '/message', arguments: MessageArguments(message, true));
      Navigator.push(context, MaterialPageRoute(builder: (context) => InAppWebViewExampleScreen(urlNoti: "${message.data["linker"]}",)));
      // Navigator.pop(context);
      // Navigator.push(context, MaterialPageRoute(builder: (context) => InAppReviewWithNotification(urlNoti: "${message.data["linker"]}",)));
    });


    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "عقارات الكويت",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      // MyApps()

    //   Scaffold(
    //   primary: true,
    //   appBar: EmptyAppBar(),
    // body:
      InAppWebViewExampleScreen()
      // )
    );
  }
}
