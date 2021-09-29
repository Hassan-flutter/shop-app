

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/cart.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
import 'package:untitledshopapp/widgets/app_drwaer.dart';
import 'package:untitledshopapp/widgets/badeg.dart';
import 'package:untitledshopapp/widgets/proudct_item.dart';

import 'cart_screen.dart';

class ProductOverviewScreen extends StatefulWidget {
  static const routeName='/ ProductOveriew ';

  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isLoadingele=false;


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
    var _keyyuihgre=GlobalKey<ScaffoldState>();
    return  Scaffold(
      key: _keyyuihgre,
      appBar: AppBar(
        title: Text("All"),
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
      body:_isLoadingele? Center(child: CircularProgressIndicator()):ProductOq(),
      drawer: AppDrawer(),
    );
  }
}
class ProductOq extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productDatawe = Provider.of<Products>(context);
    final products=productDatawe.items;
    return products.isEmpty? Center(child: Text("No products"),):
    GridView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount:products.length,
      itemBuilder: (ctx,i)=>  ChangeNotifierProvider.value(
          value: products[i],
          child:ProductItem()
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10
      ),

    );
  }
}