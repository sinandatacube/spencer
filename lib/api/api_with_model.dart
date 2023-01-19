import 'dart:convert';
import 'dart:io';
import 'package:spencer/modal/details_model.dart';
import 'package:spencer/modal/login_model.dart';
import 'package:http/http.dart' as http;
import 'package:spencer/utilities/url.dart';

Future checkLogin(LoginModal login) async {
  try {
    var response = await http.post(Uri.parse(loginUrl), body: login.toJson());
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else {
      return "Network error";
    }
  } on SocketException {
    return "Socket error";
  } catch (e) {
    return e;
  }
}

Future submitRegistration(Details data) async {
  try {
    var response =
        await http.post(Uri.parse(registrationUrl), body: data.toJson());
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    }
  } on SocketException {
    return Future.error("Socket error");
  } catch (e) {
    return Future.error(e);
  }
}
