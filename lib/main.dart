import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/auth.dart';
import 'package:untitledshopapp/providers/cart.dart';
import 'package:untitledshopapp/providers/orders.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
import 'package:untitledshopapp/screens/Catigories.dart';
import 'package:untitledshopapp/screens/Myfavourtie.dart';
import 'package:untitledshopapp/screens/cart_screen.dart';
import 'package:untitledshopapp/screens/edit_proudct_screen.dart';
import 'package:untitledshopapp/screens/ordrs_screen.dart';
import 'package:untitledshopapp/screens/product_overview_screen.dart';
import 'package:untitledshopapp/screens/proudct_detial_screen.dart';
import 'package:untitledshopapp/screens/test_screen.dart';
import 'package:untitledshopapp/screens/user_proudct_screen.dart';
import 'package:untitledshopapp/screens/splash_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth,Products>(
          create: (_)=>Products(),
          update: (ctx,authValue,privousproduct)=>privousproduct..getDate(
              authValue.token,
              authValue.userId,
              privousproduct==null?null:privousproduct.items
          ),
        ),
        ChangeNotifierProxyProvider<Auth,Orders>(
          create: (_)=>Orders(),
          update: (ctx,authValue1,privousOrders)=>privousOrders..getDate(
              authValue1.token,
              authValue1.userId,
              privousOrders==null?null:privousOrders.orders
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (ctx, AsyncSnapshot snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? SplashScreen()
                : AuthScreen(),
          ),
          routes: {
            ProductOverviewScreen.routeName:(_)=>ProductOverviewScreen(),
            ProudctDetialScreen.routeName: (_) => ProudctDetialScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrderScreen.routeName: (_) => OrderScreen(),
            UserProductScreen.routeName: (_) => UserProductScreen(),
            EditProudctScreen.routeName: (_) => EditProudctScreen(),
            TestScreen.routeName:(_)=>TestScreen(),
            MyFavourite.routeName:(_)=>MyFavourite(),
            Myclothes.routeName:(_)=>Myclothes(),
            // MyFavourite.routeName:(_)=>MyFavourite(),
          },
        ),
      ),
    );
  }
}
