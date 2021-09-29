import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/cart.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
import 'package:untitledshopapp/widgets/app_drwaer.dart';
import 'package:untitledshopapp/widgets/badeg.dart';
import 'package:untitledshopapp/widgets/proucts_gird.dart';

import 'cart_screen.dart';
class TestScreen extends StatefulWidget {
  static const routeName='/ TestScreen';

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  var _isLoadingTest=false;
  var _showOnlyFavoritesTest=false;

  @override
  void initState() {
    _isLoadingTest=true;
    Provider.of<Products>(context,listen: false).fetchAndsetProducts().then((value) {
      if (mounted) {
        setState(() {
          _isLoadingTest=false;
        });
      }
    }
    ).catchError((_){
      _isLoadingTest=false;
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var _keyzxc=GlobalKey<ScaffoldState>();
    return  Scaffold(
      key: _keyzxc,
      appBar: AppBar(
        title: Text("My cars"),
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
      body:_isLoadingTest? Center(child: CircularProgressIndicator()):ProductsGird(_showOnlyFavoritesTest),
      drawer: AppDrawer(),
    );
  }
}



