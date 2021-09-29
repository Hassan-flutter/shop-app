import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/cart.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
import 'package:untitledshopapp/widgets/app_drwaer.dart';
import 'package:untitledshopapp/widgets/badeg.dart';
import 'package:untitledshopapp/widgets/productcoll.dart';


import 'cart_screen.dart';
class Myclothes extends StatefulWidget {
  static const routeName='/ Myclothesi';

  @override
  _MyclothesState createState() => _MyclothesState();
}

class _MyclothesState extends State<Myclothes> {
  var _isLoadingMyclo=false;


  @override
  void initState() {
    _isLoadingMyclo=true;
    Provider.of<Products>(context,listen: false).fetchAndsetProducts().then((value) {
      if (mounted) {
        setState(() {
          _isLoadingMyclo=false;
        });
      }
    }
    ).catchError((_){
      _isLoadingMyclo=false;
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var _keyrede=GlobalKey<ScaffoldState>();
    return  Scaffold(
      key: _keyrede,
      appBar: AppBar(
        title: Text("My clothes"),
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
      body:_isLoadingMyclo? Center(child: CircularProgressIndicator()):ProductExit(),
      drawer: AppDrawer(),
    );
  }
}



