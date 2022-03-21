import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class ErrorScreen extends StatefulWidget {
  @override
  _ErrorState createState() => _ErrorState();
}

class _ErrorState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.autorenew ,
            color: Color(4284572262),
            size: 128.0,
          ),

         /* Icon(
            Icons.tap_and_play ,
            color: Color(4284572262),
            size: 60.0,
          )*/
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

          // 60966060

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "لمزيد من الاستفسار",
              style: TextStyle(
                  color: Color(4284572262),
                  fontSize: 18.0,
                  //fontWeight: FontWeight.bold
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InkWell(
              onTap: () async {
               await launch("tel:+96566242264");
              },
              child: Text(
                "+965 66242264",
                textDirection: TextDirection.ltr,
                style: TextStyle(

                  color: Color(4284572262),
                  fontSize: 15.0,
                  //fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}
