

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitledshopapp/providers/proudct.dart';
import 'package:untitledshopapp/providers/proudcts.dart';
class   EditProudctScreen extends StatefulWidget {
  static const routeName='/ editprouct';

  @override
  _EditProudctScreenState createState() => _EditProudctScreenState();
}

class _EditProudctScreenState extends State<EditProudctScreen> {
  final _priceFocusNode=FocusNode();
  final _descriptionFocusNode=FocusNode();
  final _imageController=TextEditingController();
  final _imageUrlFocusNode=FocusNode();
  final _fromKey=GlobalKey<FormState>();
   var _editedProduct=Product(
       id: null,
       title: '',
       descrption: '',
       type: '',
       price: 0,
       imageUrl: ''
   );
   var _initialValues={
     'title': '',
     'descrption': '',
     'type':'',
     'price': '',
    ' imageUrl': ''
   };
   var _isIntit=true;
   var _isLoading=false;
   var radiobutton="";
   var value12;

   @override
  void initState() {
     _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void didChangeDependencies() {

    if(_isIntit){
      final productId=ModalRoute.of(context).settings.arguments as String;
      if(productId !=null){
        _editedProduct=Provider.of<Products>(context,listen: false).findById(productId);
        _initialValues={
          'title':_editedProduct.title,
          'descrption':_editedProduct.descrption,
          'type':_editedProduct.type,
          'price':_editedProduct.price.toString(),
          'imageUrl':''
        };
        _imageController.text=_editedProduct.imageUrl;
      }
      _isIntit=false;
    }
    super.didChangeDependencies();
  }
  @override
  void dispose() {
   _imageUrlFocusNode.removeListener(_updateImageUrl);
   _priceFocusNode.dispose();
   _imageUrlFocusNode.dispose();
   _imageController.dispose();
   _descriptionFocusNode.dispose();
    super.dispose();
  }
  void _updateImageUrl() {
     if( !_imageUrlFocusNode.hasFocus){
       if((!_imageController.text.startsWith('http')&&
            !_imageController.text.startsWith('https'))||
           (!_imageController.text.endsWith('.png')
               &&!_imageController.text.endsWith('.jpg')
               ||!_imageController.text.endsWith('jpeg'))){
         return;
       }
       setState(() {});
     }
  }
  Future <void> _saveForm()async{
     final isValid=_fromKey.currentState.validate();
     if( !isValid){
       return ;
     }
     _fromKey.currentState.save();
     setState(() {
       _isLoading=true;
     });
     if (_editedProduct.id !=null){
       await Provider.of<Products>(context,listen: false).updateProduct(_editedProduct.id, _editedProduct);
     }
     else{
       try{
         await Provider.of<Products>(context,listen: false).addProduct(_editedProduct);

       }
       catch(e){
         await showDialog(context: context,builder: (ctx)=>AlertDialog(
           title: Text("An error occurd"),
           content: Text("Sometimes went wrong."),
           actions: [
             TextButton(
                 onPressed: ()=> Navigator.of(ctx).pop(),
                 child: Text('Okey!'))
           ],
         ),
         );
       }

     }
     setState(() {
       _isLoading=false;
     });
     Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Product"),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body:_isLoading? Center(child: CircularProgressIndicator())
          :Padding(
        padding: EdgeInsets.all(16),
        child: Form(key: _fromKey,child: ListView(
          children: [
            TextFormField(
              initialValue: _initialValues['title'],
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value){
                if(value.isEmpty){
                  return "Please provide a value";
                }
                return null;
              },
              onSaved: (value){
                _editedProduct=Product(
                  id: _editedProduct.id,
                  price: _editedProduct.price,
                  title:value,
                  descrption: _editedProduct.descrption,
                  imageUrl: _editedProduct.imageUrl,
                  type: _editedProduct.type,
                  isFavorite: _editedProduct.isFavorite,
                );
              },
            ),
            TextFormField(
              initialValue: _initialValues['price'],
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(_descriptionFocusNode);
              },
              validator: (value){
                if(value.isEmpty){
                  return "Please enter a  price";
                }
                if(double.tryParse(value)==null){
                  return "Please enter a valid number";
                }
                if(double.parse(value)<= 0){
                  return "Please enter a  number grater zero";
                }
                return null;
              },
              onSaved: (value){
                _editedProduct=Product(
                    id: _editedProduct.id,
                    price: double.parse(value),
                    title:_editedProduct.title,
                    descrption: _editedProduct.descrption,
                    imageUrl: _editedProduct.imageUrl,
                    type: _editedProduct.type,
                    isFavorite: _editedProduct.isFavorite
                );
              },
            ),
            TextFormField(
              initialValue: _initialValues['descrption'],
              decoration: InputDecoration(labelText: 'Descrption'),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descriptionFocusNode,
              validator: (value){
                if(value.isEmpty){
                  return "Please enter a descrption ";
                }
                if(value.length <10){
                  return "Should be at least 10";
                }
                return null;
              },
              onSaved: (value){
                _editedProduct=Product(
                    id: _editedProduct.id,
                    price:_editedProduct.price,
                    title:_editedProduct.title,
                    descrption:value,
                    imageUrl: _editedProduct.imageUrl,
                    type: _editedProduct.type,
                    isFavorite: _editedProduct.isFavorite
                );
              },
            ),


            // TextFormField(
            //   initialValue: _initialValues['type'],
            //   decoration: InputDecoration(labelText: 'type'),
            //   textInputAction: TextInputAction.next,
            //   validator: (value){
            //     if(value.isEmpty){
            //       return "Please provide a value";
            //     }
            //     return null;
            //   },
            //   onSaved: (value){
            //     _editedProduct=Product(
            //       id: _editedProduct.id,
            //       price: _editedProduct.price,
            //       title:_editedProduct.title,
            //       descrption: _editedProduct.descrption,
            //       imageUrl: _editedProduct.imageUrl,
            //       type: value,
            //       isFavorite: _editedProduct.isFavorite,
            //     );
            //   },
            // ),
            Row(
              children: [
                buildRow("electrical"),
                buildRow("cars"),
                buildRow("clothes"),
              ],
            ),
            Row(
             crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width:100,
                  height:100 ,
                  margin: EdgeInsets.only(top: 8,right: 10),
                  decoration: BoxDecoration(border:Border.all(
                    width: 1,
                    color: Colors.grey
                  ),
                  ),
                  child: _imageController.text.isEmpty ?Text("Enter a url"):
                      FittedBox(
                        child: Image.network(_imageController.text,fit: BoxFit.cover,),
                      ),
                ),
                Expanded(child:  TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(labelText: 'ImageUrl'),
                  keyboardType: TextInputType.url,
                  focusNode: _imageUrlFocusNode,
                  validator: (value){
                    if(value.isEmpty){
                      return "Please enter a Image Url ";
                    }
                    if(!value.startsWith('http') &&!value.startsWith('https') ){
                      return "Please enter a valid URL";
                    }
                    if(!value.endsWith('png') &&!value.endsWith('jpg')&&!value.endsWith('jpeg') ){
                      return "Please enter a valid URL";
                    }
                    return null;
                  },
                  onSaved: (value){
                    _editedProduct=Product(
                        id: _editedProduct.id,
                        price:_editedProduct.price,
                        title:_editedProduct.title,
                        descrption:_editedProduct.descrption,
                        imageUrl: value,
                        type: _editedProduct.type,
                        isFavorite: _editedProduct.isFavorite
                    );
                  },
                ),)
              ],
            ),
          ],
        ),),
      ),
    );
  }
Row buildRow(String value){
     return Row(
       children:[
         Radio(
           value: value,
           groupValue: radiobutton,
           onChanged: (val){
             setState(() {
               radiobutton=val;
               _editedProduct=Product(
                   id: _editedProduct.id,
                   title: _editedProduct.title,
                   descrption: _editedProduct.descrption,
                   price: _editedProduct.price,
                   imageUrl: _editedProduct.imageUrl,
                   type: radiobutton
               );
             });
           },
         ),
         Text(value),
       ]
     );
}
}
