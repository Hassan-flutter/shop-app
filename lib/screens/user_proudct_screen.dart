import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
import 'package:untitledshopapp/screens/edit_proudct_screen.dart';
import 'package:untitledshopapp/widgets/app_drwaer.dart';
import 'package:untitledshopapp/widgets/user_product_item.dart';
class UserProductScreen extends StatelessWidget {
  static const routeName='/ user-products';


Future<void> _refreshProducts (BuildContext context) async{
  await Provider.of<Products>(context,listen: false).fetchAndsetProducts(true);
}
Widget selectTv(){
  if(Platform.isIOS){
    return CupertinoActivityIndicator(
    );
  }
  else {
  return CircularProgressIndicator(
    color: Colors.pink,
  );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("your Products"),
        actions: [
          IconButton(icon:Icon(Icons.add),
              onPressed: ()=> Navigator.of(context).pushNamed(EditProudctScreen.routeName),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx,AsyncSnapshot snapshot)=>
        snapshot.connectionState==ConnectionState.waiting? Center( child: selectTv())
              : RefreshIndicator(
                onRefresh:()=> _refreshProducts(context),
                child: Consumer<Products>(
                  builder:(ctx,prodDate,_)
                => Padding(padding:EdgeInsets.all(8),
                    child: ListView.builder(
                      itemCount:prodDate.items.length ,
                      itemBuilder: (_,int index)=>Column(
                        children: [
                          UserProductItem(
                            prodDate.items[index].id,
                            prodDate.items[index].title,
                            prodDate.items[index].imageUrl,),
                          Divider(),

                        ],
                      ),
                  ),
                ),) ,
                )
      ),


    );
  }
}
