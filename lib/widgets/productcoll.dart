import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
import 'package:untitledshopapp/widgets/proudct_item.dart';
class ProductExit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productDataJK = Provider.of<Products>(context);
    final products=productDataJK.good23t43;
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
