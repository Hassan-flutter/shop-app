import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/cart.dart';
import 'package:untitledshopapp/providers/auth.dart';
import 'package:untitledshopapp/screens/proudct_detial_screen.dart';
import 'package:untitledshopapp/providers/proudct.dart';
class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product=Provider.of<Product>(context,listen: false);
    final cart=Provider.of<Cart>(context,listen: false);
    final authData=Provider.of<Auth>(context,listen: false);
    return ClipRRect(borderRadius:BorderRadius.circular(10),
        child: GridTile(
          child: GestureDetector(onTap:()=>Navigator.of(context).pushNamed(
              ProudctDetialScreen.routeName,
            arguments: product.id,
          )
            ,child: Hero(
                tag: product.id,
                child: FadeInImage(
                  placeholder:AssetImage('assets/images/product-placeholder.png') ,
                  image: NetworkImage(product.imageUrl),
                  fit: BoxFit.cover,
                ),
              )
          ),
          footer: GridTileBar(
            backgroundColor:Colors.black87,
            leading:Consumer<Product>(builder:(ctx,product,_)=>IconButton(
                icon: Icon(product.isFavorite?Icons.favorite:Icons.favorite_border ),
                color: Theme.of(context).accentColor,
                onPressed: (){
                  product.toggleFaviorit(authData.token, authData.userId);
                }
            ) ,
            ) ,
            title:Text(product.title,textAlign: TextAlign.center,) ,
            trailing: IconButton(
              color: Theme.of(context).accentColor,
              icon:Icon(Icons.add_shopping_cart) ,
              onPressed:(){
                cart.addItem(product.id, product.price, product.title);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(content: Text("Added to cart"),
                  duration: Duration(seconds: 5),
                  action: SnackBarAction(label:'Undo' ,onPressed: (){
                    cart.removeSingleItem(product.id);
                  },),
                )) ;
              } ,
            ),
          ),
        ),
    );
  }
}
