import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


const String baseUrl = "https://1309-197-156-130-11.ngrok-free.app";
const String apisUrl = "$baseUrl/api";
const String accountActivationURL = "$apisUrl/users";
const String confirmOTPURL = "$apisUrl/confirm_otp";
const String setPasswordURL = "$apisUrl/set_password";
const String loginURL = "$apisUrl/login";
const String fetchExercisesURL = "$apisUrl/search_exercise";
const String participateURL = "$apisUrl/participate_in_exercise";
const String imageUpload = "$apisUrl/upload_image";
const String plantTree = "$apisUrl/plant_tree";
 String tscNo = "";

void toast(String message){
 Fluttertoast.showToast(
  msg: message,
  toastLength: Toast.LENGTH_SHORT,
  gravity: ToastGravity.BOTTOM,
  backgroundColor: Colors.black,
  textColor: Colors.white,
 );
}

Future<String> postStringRequest(Map data, String url) async {

 try{
  var response = await http.post(
      Uri.parse(url),
      headers:<String, String>{
       'Content-Type': 'application/json; charset=UTF-8',
      },
      body:jsonEncode(data)
  );
  return response.body;
 }catch(e){
  return e.toString();
 }
}

