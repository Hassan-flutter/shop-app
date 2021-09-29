import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
class ProudctDetialScreen extends StatelessWidget {
  static const routeName='/ product-datial';
  @override
  Widget build(BuildContext context) {
    final prodcuctId=ModalRoute.of(context).settings.arguments as String ;
    final loadProduct=Provider.of<Products>(context,listen: false).findById(prodcuctId);
    return Scaffold(
      appBar: AppBar(title: Text("Hassan"),),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title:Text(loadProduct.title) ,
              background:Hero(
                tag:loadProduct.id ,
                child:Image.network(
                  loadProduct.imageUrl,
                  fit: BoxFit.cover,
                ) ,
              ) ,),
          ),
          SliverList(delegate: SliverChildListDelegate(
            [
              SizedBox(height: 10),
              Text('${loadProduct.price}',
                style: TextStyle(color: Colors.grey,fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(loadProduct.descrption,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              )
            ],
          ),
          ),
        ],
      )
    );
  }
}
