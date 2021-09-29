import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String descrption;
  final double price;
  final String imageUrl;
  final String type;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.descrption,
    @required this.price,
    @required this.imageUrl,
    @required this.type,
    this.isFavorite=false
  });
  void _setFavValue(bool newValue){
    isFavorite=newValue;
    notifyListeners();
  }
  Future <void> toggleFaviorit(String token,String userId)async{
    final oldSate=isFavorite;
    isFavorite=!isFavorite;
    notifyListeners();
    final url='https://shop-da072-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try{
      final  res=await http.put(
          Uri.parse(url),
          body: json.encode(isFavorite)
      );
      if(res.statusCode >=400){
        _setFavValue(oldSate);
      }
    }
    catch(e){
      _setFavValue(oldSate);
    }
  }
}