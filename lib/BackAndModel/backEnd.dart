
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'DataResponseSendToken.dart';
class BackEnd{

  // ignore: missing_return
  static Future<DataResponseSendToken?> sendToken(
      {Map? body, device, token, version,buildNumber,linker}) async{

    final encoding = Encoding.getByName('utf-8');
    String jsonBody = json.encode(body);
    // final headers = {'Content-Type': 'application/json'};

    final headers = {'Secret': 'flutter2021','Device':'$device','Token':'$token','Version':'$version','Build':'$buildNumber','Linker':'${linker.toString()}'};

    print(linker.toString()+"?????????????");
    print("body<<  "+body.toString());
    print("headers<<  "+headers.toString());

    print("https://q8aqar.com/inc/app/json.php");

    print(jsonBody.toString());
    var responce = await http.post(
      Uri.parse("https://q8aqar.com/inc/app/json.php"),
      body:body,
      encoding: encoding,
      headers: headers,
    );

    // print(Uri.parse("https://q8aqar.com/inc/app.php"));

    print("?>>>>  "+responce.statusCode.toString());
    print("?>>>>  "+json.decode(responce.body).toString());
    try{
      if(responce.statusCode==200){

        DataResponseSendToken dataMyOrder=DataResponseSendToken.fromJson(json.decode(responce.body));
        return dataMyOrder;

      }else if(responce.statusCode==404){
        return json.decode(responce.body);
      }else{
        print(">>>>>>>>>>>>"+responce.statusCode.toString());
        print(responce.body.toString());
      }
      print(">>>>>>>>>>>>"+responce.statusCode.toString());
      print(responce.body.toString());
    }catch(e){
      print(">>>>>>>>>>>>"+responce.statusCode.toString());
      print(responce.body.toString());
      throw "error fetch data";
    }
  }
}