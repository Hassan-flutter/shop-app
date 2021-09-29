import 'package:flutter/material.dart';
import 'package:untitledshopapp/screens/product_overview_screen.dart';
class CatgoeryItem   extends StatelessWidget {

  final String title;
  final Color color;
  final Object keyd;

  CatgoeryItem( this.title,this.color,this.keyd);
  // void Selectsreen(BuildContext ctx){
  //   Navigator.of(ctx).pushNamed(ProductOverviewScreen.routeName,arguments: {
  //     'keyds':keyd,
  //   });
  // }


  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () =>keyd,
      splashColor: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Text(title),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.7),
              color,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}