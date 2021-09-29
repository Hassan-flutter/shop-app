import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/screens/Catigories.dart';
import 'package:untitledshopapp/screens/Myfavourtie.dart';
import 'package:untitledshopapp/screens/ordrs_screen.dart';
import 'package:untitledshopapp/screens/test_screen.dart';
import 'package:untitledshopapp/screens/user_proudct_screen.dart';
import 'package:untitledshopapp/providers/auth.dart';
import 'package:untitledshopapp/providers/auth.dart';
import 'package:untitledshopapp/screens/ordrs_screen.dart';
import 'package:untitledshopapp/screens/user_proudct_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(title: Text('Hello Friend'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.shop) ,
            title: Text("Shop"),
            onTap:()=> Navigator.of(context).pushReplacementNamed('/') ,
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.payment) ,
            title: Text("Ordes"),
            onTap:()=> Navigator.of(context).pushReplacementNamed(OrderScreen.routeName) ,
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.edit) ,
            title: Text("Mange Products"),
            onTap:()=> Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName) ,
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.exit_to_app) ,
            title: Text('Log out'),
            onTap:(){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context,listen: false).logout();
            } ,
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.edit) ,
            title: Text("My ele"),
            onTap:()=> Navigator.of(context).pushReplacementNamed(MyFavourite.routeName) ,
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.edit) ,
            title: Text("My CARS"),
            onTap:()=> Navigator.of(context).pushReplacementNamed(TestScreen.routeName) ,
          ),
          Divider(),
          ListTile(
            leading:Icon(Icons.edit) ,
            title: Text("My CLO"),
            onTap:()=> Navigator.of(context).pushReplacementNamed(Myclothes.routeName) ,
          ),
        ],
      ),
    );
  }
}
