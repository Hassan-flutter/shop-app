import 'package:flutter/material.dart';
import 'package:untitledshopapp/widgets/app_drwaer.dart';
import 'package:untitledshopapp/widgets/order_item.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/orders.dart' show Orders;
class OrderScreen extends StatelessWidget {
  static const routeName='/ orderscreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("your Order")),
      drawer: AppDrawer(),
      body:FutureBuilder(
          future: Provider.of<Orders>(context,listen: false).fetchAndsetOrders(),
          builder: (ctx,AsyncSnapshot snapshot){
            if(snapshot.connectionState ==ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            }
            else{
              if(snapshot.error !=null){
                return Center(child: Text('An error occurred'),);
              }
              else{
                return Consumer<Orders>(builder: (ctx,orderData,child)=>ListView.builder(
                    itemCount:orderData.orders.length ,
                    itemBuilder: (BuildContext context,int index)=>OrderItems(orderData.orders[index])
                ) ,
                );
              }
            }

          }
      ),
    );
  }
}