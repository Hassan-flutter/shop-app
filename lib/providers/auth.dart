import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'package:untitledshopapp/models/http_exption.dart';
class Auth with ChangeNotifier{
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTime;
  bool get isAuth{
    return token !=null;
  }

  String get token{
    if(_expiryDate !=null && _expiryDate.isAfter(DateTime.now())&& _token !=null){
      return _token;
    }
    return null ;
  }
  String get userId{
    return _userId;
  }
  Future <void> _authenticate(String email,String password,String urlSeg) async{
final url='https://identitytoolkit.googleapis.com/v1/accounts:$urlSeg?key=AIzaSyDHAoeaDzykR2v-VDkWChyC_62hsVlP24A';


try{
  final res=await http.post(Uri.parse(url),body: json.encode({
    'email':email,
    'password':password,
    'returnSecureToken':true,
  }));
  final responDate=json.decode(res.body);
  if(responDate['error'] !=null){
   throw HttpExption(responDate['error']['message']);
  }
  _token=responDate['idToken'];
  _userId=responDate['localId'];
  _expiryDate=DateTime.now().add(Duration(seconds: int.parse(responDate['expiresIn'])));
  _autoLogot();
notifyListeners();
  final prefs = await SharedPreferences.getInstance();
String userDate=json.encode({
  'token':_token,
  'userId':_userId,
  'expiryDate':_expiryDate.toIso8601String()
});
prefs.setString('userDate', userDate);
}
catch(e){
throw e;
}
  }
  Future <void> signUp(String email,String password) async{
    return _authenticate(email, password, "signUp");
  }
  Future <void> login(String email,String password) async{
    return _authenticate(email, password, "signInWithPassword");
  }
  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if( !prefs.containsKey('userDate')) return false;
    final Map<String,Object> extrectDate=json.decode(prefs.getString('userDate')) as  Map<String,Object>;
    final experyDate=DateTime.parse(extrectDate['expiryDate']);
    if (experyDate.isBefore(DateTime.now())) return false ;
    _token=extrectDate['token'];
    _userId=extrectDate['userId'];
    _expiryDate=experyDate;
    notifyListeners();
    _autoLogot();
    return true;
  }
  Future<void> logout()async{
_token=null;
_userId=null;
_expiryDate=null;
if(_authTime !=null){
  _authTime.cancel();
  _authTime=null;
}
notifyListeners();
final prefs = await SharedPreferences.getInstance();
prefs.clear();
  }
  void _autoLogot(){
    if(_authTime !=null){
      _authTime.cancel();
    }
    final timeToExpry=_expiryDate.difference(DateTime.now()).inSeconds;
    _authTime=Timer(Duration(seconds: timeToExpry),logout);
  }
}