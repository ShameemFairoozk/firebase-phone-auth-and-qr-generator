import 'dart:convert';

import 'package:firbase_auth_flutter/models/Ip_model.dart';
import 'package:http/http.dart' as http;

class ApiService{


  Future<IpModel?> getIp() async {
    var client=http.Client();

    IpModel? ipmodel;


    try {

      var response = await client.get(Uri.parse("http://ip-api.com/json"));
      if (response.statusCode == 200) {
        var jsonString = response.body;

        var jsonMap = json.decode(jsonString);
        ipmodel = IpModel.fromJson(jsonMap);
        return ipmodel;
      }
    }
    catch(exp){
      return ipmodel;

    }

    return ipmodel;
  }
}