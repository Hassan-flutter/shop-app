import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitledshopapp/providers/cart.dart';
import 'package:http/http.dart'as http;
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;


  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}
class Orders with ChangeNotifier{
List <OrderItem> _orders=[];
String authToken;
String userId;
getDate(String authMaster,String uId, List<OrderItem> orders ){
  authToken=authMaster;
  userId=uId;
  _orders=orders;
  notifyListeners();
}
List<OrderItem> get orders{
  return [..._orders];
}
Future <void> fetchAndsetOrders() async {
  final url='https://shop-da072-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
  try{
    final res=await http.get(Uri.parse(url));
    final extractedDate=json.decode(res.body) as Map <String,dynamic>;
    if(extractedDate==null){
      return ;
    }

    final List <OrderItem> loadOrders=[];
    extractedDate.forEach((orderId, orderDate) {
      loadOrders.add(OrderItem(
        id: orderId,
        amount: orderDate['amount'],
        dateTime: DateTime.parse(orderDate['dateTime']),
        products: (orderDate['products'] as List <dynamic>).map((item) => CartItem(
            id: item['id'],
            title: item['title'],
            quantity: item['quantity'],
            price: item['price'],
        )).toList(),
      ));
    });
    _orders=loadOrders.reversed.toList();
    notifyListeners();
  }
  catch(e){
    throw e;
  }
}
Future<void> addOrder(List <CartItem> cartProduct,double total )async{
  final url='https://shop-da072-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
  try{
    final timestamp=DateTime.now();
    final res=await http.post(Uri.parse(url),body: json.encode({
      'amount':total,
      'dateTime':timestamp.toIso8601String(),
      'products':cartProduct.map((cp) => {
        'id':cp.id,
        'title':cp.title,
        'quantity':cp.quantity,
        'price':cp.price
      }).toList(),
    }));
    _orders.insert(0, OrderItem(
      id: json.decode(res.body)['name'],
      amount: total,
      dateTime: timestamp,
      products:cartProduct,
    ));
    notifyListeners();
  }
  catch(e){
    throw e;
  }
}
}