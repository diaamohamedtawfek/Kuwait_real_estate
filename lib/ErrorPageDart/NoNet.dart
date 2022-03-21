import 'package:aqarr_elquet/SplashScrean.dart';
import 'package:flutter/material.dart';

class NoNet extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return UiNoNet();
  }
}

class UiNoNet extends State<NoNet> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              Icons.autorenew ,
              color: Color(4284572262),
              size: 128.0,
            ),


            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Text(
                "خطأ في الاتصال",
                style: TextStyle(
                    color: Color(4284572262),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SplashScrean()));
              },
              color: Colors.blue,
              child: Text("اعاده المحاوله"),
            )

          ],
        ),
      ),
    );
  }
}