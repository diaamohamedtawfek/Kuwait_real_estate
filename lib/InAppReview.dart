import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:aqarr_elquet/BackAndModel/DataResponseSendToken.dart';
import 'package:aqarr_elquet/SplashScrean.dart';
import 'package:aqarr_elquet/ErrorPageDart/netallow.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'BackAndModel/backEnd.dart';
import 'ErrorPageDart/Error.dart';


class InAppWebViewExampleScreen extends StatefulWidget {
  final DataResponseSendToken? dataResponseSendToken;
  final String? urlNoti;

  const InAppWebViewExampleScreen({Key? key, this.dataResponseSendToken, this.urlNoti}) : super(key: key);
  @override
  _InAppWebViewExampleScreenState createState() =>
      new _InAppWebViewExampleScreenState();
}




class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {

  final GlobalKey webViewKey = GlobalKey();


  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));




  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "https://q8aqar.com/inc/app/index.php";
  String urlstart = "";
  double progress = 0;
  final urlController = TextEditingController();
  List<dynamic> urls=[
    "https://q8aqar.com"
  ];

  // * NetWOrk
  bool net = true ;
  MyConnectivity _connectivity = MyConnectivity.instance;
  Map _source = {ConnectivityResult.none: true};


  // *  showNativeApp = 0;
  int? showNativeApp;

  @override
  void initState() {
    super.initState();


    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });


    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );



    // * Notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(Platform.isIOS){
        print(message.toString());
      }
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');


      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification?.title}');
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+message.toString());
        print("/n/n/n");
        FlutterLocalNotificationsPlugin? fltrNotification;
        var androidInitilize = new AndroidInitializationSettings('location');
        var iOSinitilize = new IOSInitializationSettings();
        var initilizationsSettings =
        new InitializationSettings(android: androidInitilize, iOS: iOSinitilize);
        fltrNotification = new FlutterLocalNotificationsPlugin();
        fltrNotification.initialize(
          initilizationsSettings,
          // onSelectNotification: notificationSelected
        );
        print(message.toString());
        showNotification("${message.notification!.body}",message.notification!.title.toString(),message.data);
      }else{
        print(message.toString());
      }
    });


    // * Send Token
    appLinker=widget.urlNoti.toString();

    sendToken(widget.urlNoti.toString());

    setingNotification();

    // * Timer Splash
    // Timer(Duration(seconds: 3),(){
    //   setState(() {
        ceckNet();
    //   });
    // });

  }

  var appLinker;

  // * setingNotification
  Future<void> setingNotification() async {
    // NotificationSettings settings =
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    // sendToken();
  }


  Future showNotification(String? s,String title,Map<String, dynamic> mas) async {
    print("showNotification>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+s.toString());
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('location');

    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotifications
    );

    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();


    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        "1344", "عقارات الكويت", "see",
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true
    );

    const IOSNotificationDetails iosNotificationDetails=IOSNotificationDetails(

    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosNotificationDetails

    );


    try{
      await flutterLocalNotificationsPlugin.show(
        1344, "$title", "$s", platformChannelSpecifics,
        // payload: '${mas["data"]["offer"].toString()}'
      );
    }catch(e){
      print(e.toString()+">>>");
    }

  }


  Future onSelectNotification(String? payload) async {
    debugPrint("payload : $payload");
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ErrorScreen()));

    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => ErrorScreen()),
    // );
  }



  Future onDidReceiveLocalNotifications(
      int? id, String? title, String? body, String? payload) async {
    // dilog or any
  }

  int showSplash=0;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  var nameAddItem="";
  var urlAddItem="";
  int testSendToken=0;


  // * Send Token /.<<<<<<<<<<<<<<<
  sendToken(var applinker) async{

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // * Send Token
    messaging.getToken().then((token) async {

      if (Platform.isIOS) {
         Map<String, dynamic> body = {
          "apptoken":token,
          "appdevice":"ios",
          "appversion":"${packageInfo.version}",  // *>>>>>>>>
        "appbuild":packageInfo.buildNumber,
           "applinker":applinker
        };
        sendTokenFinal(body: body,token: token,package: packageInfo.version,type: "ios",buildNumber:packageInfo.buildNumber,applinker: applinker);
      }
      else{
        Map<String, dynamic> body = {
          "apptoken":token,
          "appdevice":"android",
          "appversion":"${packageInfo.version}",
          "appbuild":packageInfo.buildNumber,
          "applinker":applinker
        };
        sendTokenFinal(body: body,token: token,package: packageInfo.version,type: "android",buildNumber:packageInfo.buildNumber,applinker: applinker.toString());
      }
    });
  }
  sendTokenFinal({ body,token,package,type,buildNumber,applinker}){
    fetckDataFromToken = BackEnd.sendToken(body: body,device: "$type",token: token,version:package,buildNumber: buildNumber,linker: applinker.toString());
    fetckDataFromToken!.then((value) => {
      setState(() {
        testSendToken=1;
        try{
          urlstart=value!.place!;
        }catch(w){}

      }),

      if(value!.place!.toString()==""){
        Timer(Duration(seconds: 2),(){
          setState(() {
            sendToken(applinker.toString());
          });
        }),
      }else{
        Timer(Duration(seconds:
        int.parse(value.splash!.toString())>0?int.parse(value.splash!.toString())
            :2
        ),(){
          setState(() {
            // ceckNet();
            showSplash=1;
          });
        }),
      },


        // print(value!.allow),
      setState(() {
        // dataResponseSendToken=value;
        for(int i =0 ;i<value.allow!.length;i++){
          setState(() {
            urls.add("${value.allow![i]}/");
          });

        }

        setState((){
          showNativeApp=int.parse(value.native.toString());
          print(">>>>>>  showNativeApp   >>>>>>>>>>>>>>>>>>>>>>>  $showNativeApp");

          nameAddItem=value.button!.text.toString();
          urlAddItem=value.button!.url.toString();
          print(">>>>>>  nameAddItem   >>>>>>>>>>>>>>>>>>>>>>>  $nameAddItem");

        });
      })
    });
  }

  Future<DataResponseSendToken?>? fetckDataFromToken;

  @override
  void dispose() {
    super.dispose();
    _connectivity.disposeStream();
  }


  Future<bool> _exitApp(BuildContext context) async {
    print('presssssssssssssssssssssssss');
    webViewController!.goBack();
    return Future.value(true);
  }


  Future<bool?> ceckNet() async{
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
          setState(() {
            net = true;
          });
      }
      return Future.value(true);
    } on SocketException catch (_) {
      print('not connected');
      setState(() {
        net = false;
      });
    }
    return Future.value(false);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int ceckNetNummer=0;
  bool neterroro=true;



  @override
  Widget build(BuildContext context) {
    print(_source.keys.toList()[0]);
    // ceckNet();
    if (_source.keys.toList()[0] == ConnectivityResult.none) {
      setState(() {
        net = false;
        neterroro = false;
        ceckNetNummer++;
        print(ceckNetNummer.toString()+">????????>>>>>>>>>>");
        if(ceckNetNummer>0){
          // Navigator.pushReplacementNamed(context, '/');
          print("::::::::::::::::::$ceckNetNummer::::::::::");
        }
      });
    } else {
      setState(() {
        net = true;
        neterroro = true;
        // ceckNetNummer--;
        ceckNetNummer=0;
        print(ceckNetNummer.toString()+">????????>>>>>>>>>>");
      });

      if(showNativeApp==null &&showSplash == 1 && testSendToken==0 && neterroro==false){
        sendToken(appLinker.toString() );
      }
    }



    //  * Bailed  Home >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return
       SafeArea(
           top: false,
           bottom: false,
           child:  Directionality(
           textDirection: TextDirection.rtl,
           child: WillPopScope(
               onWillPop: () => _exitApp(context),
               child:futherBody()// * body App >>>>>>>>>>>>>>>>>>>>
           )
       )

    )
    ;
  }

  String appName = "عقارات الكويت";
  Future<void> shareInterface(List<dynamic> params) async{
    print(">>>>>>>>>>>>>>>>>");
    print(params[0].toString());
    print(params[1].toString());
    print(params[0]);
    await FlutterShare.share(
        title: appName,
        text: params[0].toString(),
        linkUrl: params[1].toString(),
        chooserTitle: appName
    );
  }

  void addClipboardHandlersOnly(InAppWebViewController webview) {
    webview.addJavaScriptHandler( handlerName: "ShareInterface",callback:shareInterface);
  }


  _launchURLgg(urls) async {
    print("?????????????????");
    if (await canLaunch(urls)) {
      if(Platform.isIOS){
        await launch(urls,forceSafariVC: false,);
      }else{
        await launch(urls);
    }
    } else {
      print(">>>>>>>>>>>>>>>>>>>");
      throw 'Could not launch $urls';
    }
  }


  // * List Item Draew
  Widget futherBulderAds() {
    return FutureBuilder<DataResponseSendToken?>(
      future: fetckDataFromToken, // async work
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasError) {
          return Text(
            "لا يوجد بيانات",
          );
        }
        else if (snapshot.hasData) {
          return
            snapshot.data!.links!.length <= 0 ?
            Text(
               "لا يوجد بيانات",
            )
                :
            ListView.builder(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: snapshot.data!.links!.length,
              itemBuilder: (BuildContext context, int index) {
                return Directionality(
                    textDirection: TextDirection.rtl,
                    child: InkWell(
                  onTap: () {
                    // Get.to(Item(ad_id: snapshot.data.data.ad[index].id,
                    //   titel: snapshot.data.data.ad[index].title,));
                    if(snapshot.data!.links![index].url.toString().isNotEmpty && snapshot.data!.links![index].url !=null ){
                      webViewController?.loadUrl(urlRequest:URLRequest(url: Uri.parse(snapshot.data!.links![index].url.toString())));
                      Navigator.pop(context);
                    }else{
                      print(">?>?>>>>>");
                    }

                  },
                  child: Stack(
                    children: [

                     Padding(
                       padding: EdgeInsets.only(left: 18,right: 18,bottom: 15),
                       child:  Row(
                         children: [
                           snapshot.data!.links![index].url.toString().isNotEmpty && snapshot.data!.links![index].url !=null?
                           Container(
                             height: 15,
                             width: 15,
                             color: Color(0xff257AB1),
                           ):Container(),

                           SizedBox(width: 15,),
                           Text(
                               snapshot.data!.links![index].text!.toString(),
                             style: TextStyle(
                               color: snapshot.data!.links![index].url.toString().isNotEmpty && snapshot.data!.links![index].url !=null?
                               Colors.black: Colors.black45,
                               fontSize: 18
                             ),
                           ),

                         ],
                       ),
                     )
                    ],
                  ),
                )
                );
              },
            );
        }


        return Center(child: CircularProgressIndicator(),);
      },
    );
  }





  // * List Body
  Widget futherBody() {
    return FutureBuilder<DataResponseSendToken?>(
      future: fetckDataFromToken, // async work
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              backgroundColor: Colors.white,
              key: _scaffoldKey,


              // floatingActionButton:
              // FloatingActionButton(
              //   onPressed: () {
              //   },
              //   child: const Icon(Icons.notifications_none),
              //   backgroundColor:Color(0xff257AB1),
              // )
              // // :null
              // ,

              // * appBar
              appBar:
              net ?
              showSplash == 1 ?
              showNativeApp == 1 ?
              AppBar(
                brightness: Brightness.light, //
                elevation: 11,
                centerTitle: false,
                iconTheme: IconThemeData(
                    color: Colors.black
                ),
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,

                title: InkWell(
                    onTap: () {
                      //https://q8aqar.com/app/1/
                      print(url);
                      webViewController?.loadUrl(
                          urlRequest: URLRequest(url: Uri.parse(urlstart)));
                    },
                    child: Transform(
                        transform:
                        // langApp.toString()=="ar"?Matrix4.translationValues(25.0, 0.0, 20.0):
                        Matrix4.translationValues(12.0, 0.0, 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Row(
                              children: [
                                Image.asset(
                                  "assets/location.png", width: 40,),

                                SizedBox(width: 5,),
                                Text(
                                  "عقارات الكويت", style: TextStyle(
                                    color: Color(
                                        0xff257AB1), fontSize: 18),),
                              ],
                            ),

                          ],
                        )
                    )
                ),

                actions: [
                  // * Add Item
                  Visibility(
                      visible: nameAddItem.isEmpty
                          // || nameAddItem == null
                          ? false
                          : true,
                      child: InkWell(
                          onTap: () {
                            webViewController?.loadUrl(
                                urlRequest: URLRequest(url: Uri.parse(
                                    urlAddItem)));
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 9, bottom: 9, left: 0, right: 4),
                            padding: EdgeInsets.only(left: 9, right: 9),
                            // height: 33,

                            decoration: BoxDecoration(
                              color: Color(0xff257AB1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Center(
                              child: Text("${nameAddItem.toString()}",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 15),),
                            ),
                          )
                      )
                  ),


                  // * open

                  IconButton(
                    icon: Icon(Icons.format_align_justify,size: 33,),
                    onPressed: () {
                      // SystemChannels.textInput.invokeMethod('TextInput.hide');
                      _scaffoldKey.currentState!.openDrawer();
                    },

                  ),
                ],

              )
                  : null : null: null,


              // * Drawer
              drawer: showNativeApp == 1 ? SizedBox(
                width: (MediaQuery
                    .of(context)
                    .size
                    .width / 100) * 75,
                child: Drawer(
                    child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ListView(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          children: [
                            // * List  Drawer
                            SizedBox(height: 33,),
                            futherBulderAds(),
                          ],
                        )
                    ) // We'll populate the Drawer in the next step!
                ),
              ) : null,

              body:
              SafeArea(
                top: showNativeApp ==0?true:false,
                  bottom: false,
                  child:
              Column(children: <Widget>[
                Expanded(
                  child: Stack(
                    children: [


                      Container(
                          padding: EdgeInsets.all(0.0),
                          child: progress < 1.0
                              ? Center(
                            child: CircularProgressIndicator(),)
                              : Container()),


                      net ?
                      snapshot.data!.place.toString()!="" ?
                      neterroro ?
                      // urlstart!=""?

                      InAppWebView(
                        onLongPressHitTestResult: (controller, hitTestResult) => {
                          print(hitTestResult.toString())
                        },
                        key: webViewKey,
                        initialUrlRequest:
                        URLRequest(url: Uri.parse(snapshot.data!.place!)),
                        initialUserScripts: UnmodifiableListView<
                            UserScript>([
                        ]),
                        initialOptions: options,

                        pullToRefreshController: pullToRefreshController,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        androidOnPermissionRequest: (controller, origin,
                            resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction
                                  .GRANT);
                        },

                        shouldOverrideUrlLoading: (controller,
                            navigationAction) async {
                          var uri = navigationAction.request.url!
                              .toString();
                          print("||||||||||||||||" + url);
                          print("||||||||||||||||" + uri.toString());

                          // *  ??????????????????????????????????????????????????????????????????????
                          var _canLoad = urls.where((item) =>
                              navigationAction.request.url!
                                  .toString().startsWith(item)).toList();

                          if (_canLoad.length < 1) {
                            print("_canLoad.length");
                            if(uri.contains("tel:")){
                              
                            }
                            _launchURLgg(uri);
                            print(uri);
                            return NavigationActionPolicy.CANCEL;
                          } else {
                            print(
                                "000000000000000000000000000000000000000000000");
                            return NavigationActionPolicy.ALLOW;
                          }
                        },


                        onLoadStop: (controller, url) async {
                          addClipboardHandlersOnly(webViewController!);

                          pullToRefreshController.endRefreshing();
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onLoadError: (controller, url, code, message) {
                          print(message.toString()+">>>>> eerrorrr >>>>>>>>");
                          print(code.toString()+">>>>> eerrorrr >>>>>>>>");
                          pullToRefreshController.endRefreshing();
                          if(messaging.toString()=="net::ERR_ADDRESS_UNREACHABLE"||code==-2){
                            print(code.toString()+">>>>> eerrorrr ********>>>>>>>>");
                            setState(() {
                              net=false;
                              neterroro=false;
                            });
                          }
                        },
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            pullToRefreshController.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                            urlController.text = this.url;
                          });
                        },
                        onUpdateVisitedHistory: (controller, url,
                            androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                            urlController.text = this.url;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                      )
                          : Container(
                        child: ErrorScreen(),
                      ):
                          Center(child: SplashScrean(),):
                      Container(
                        child: ErrorScreen(),
                      ),

                      // ),

                      Visibility(
                        visible:
                        showSplash != 0 ? false :
                        snapshot.data!.place.toString()=="" ? false :
                        true,
                        child: SplashScrean(),)


                    ],
                  ),
                )
              ]
              )
            )
          );
        }
        else{
          return SplashScrean();
        }
      },
    );
  }
}
