// import 'package:flutter/material.dart';
// import 'package:untitledshopapp/widgets/app_drwaer.dart';
// import 'package:provider/provider.dart';
// import 'package:untitledshopapp/providers/proudcts.dart';
// import 'package:untitledshopapp/widgets/proucts_gird.dart';
//
//
//
// class MyFavourite extends StatefulWidget {
//   static const routeName='/ My_Favourite';
//   @override
//   _MyFavouriteState createState() => _MyFavouriteState();
// }
//
// class _MyFavouriteState extends State<MyFavourite> {
//  var _isLoading=true;
//   var _showOnlyFavorites=true;
//
//   @override
//   void initState() {
//     _isLoading=true;
//     Provider.of<Products>(context,listen: false).fetchAndsetProducts(true,"e").then((value) {
//       if (mounted) {
//         setState(() {
//           _isLoading=false;
//         });
//       }
//     }
//     ).catchError((_){
//       _isLoading=false;
//     });
//
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     var _key=GlobalKey<ScaffoldState>();
//     return  Scaffold(
//       key: _key,
//       appBar: AppBar(
//         title: Text("My Shop"),
//       ),
//       body:_isLoading? Center(child: CircularProgressIndicator()):ProductsGird(_showOnlyFavorites),
//       drawer: AppDrawer(),
//     );
//   }
// }
//
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/cart.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
import 'package:untitledshopapp/widgets/app_drwaer.dart';
import 'package:untitledshopapp/widgets/badeg.dart';
import 'package:untitledshopapp/widgets/proucts_gird.dart';

import 'cart_screen.dart';
class MyFavourite extends StatefulWidget {
  static const routeName='/ MyFavourite ';

  @override
  _MyFavouriteState createState() => _MyFavouriteState();
}

class _MyFavouriteState extends State<MyFavourite> {
  var _isLoadingele=false;
  var _showOnlyFavorites=true;

  @override
  void initState() {
    _isLoadingele=true;
    Provider.of<Products>(context,listen: false).fetchAndsetProducts().then((value) {
      if (mounted) {
        setState(() {
          _isLoadingele=false;
        });
      }
    }
    ).catchError((_){
      _isLoadingele=false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _keyyuihg=GlobalKey<ScaffoldState>();
    return  Scaffold(
      key: _keyyuihg,
      appBar: AppBar(
        title: Text("My electrical"),
        actions: [
          Consumer<Cart>(child: IconButton(icon: Icon(Icons.shopping_cart_outlined),
              onPressed: ()=>Navigator.of(context)
                  .pushNamed(CartScreen.routeName)),
              builder:(_,cart,ch)=> Badge(
                  value: cart.itemsCount.toString(),
                  child: ch
              )
          ),
        ],
      ),
      body:_isLoadingele? Center(child: CircularProgressIndicator()):ProductsGird(_showOnlyFavorites),
      drawer: AppDrawer(),
    );
  }
}



