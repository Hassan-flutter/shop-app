import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
import 'package:untitledshopapp/widgets/proudct_item.dart';

class ProductsGird extends StatelessWidget {
  final bool showFavs;

  const ProductsGird(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products=showFavs ?productData.good:productData.good23;
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
