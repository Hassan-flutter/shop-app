import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitledshopapp/models/http_exption.dart';
import 'package:untitledshopapp/providers/proudct.dart';
class Products with ChangeNotifier{
  List<Product> _items = [
    // Product(a
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   descrption: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //   'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   descrption: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   descrption: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //   'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   descrption: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //   'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  String authToken;
  String userId;
  getDate(String authhass,String uId, List<Product>Products ){
    authToken=authhass;
    userId=uId;
    _items=Products;
    notifyListeners();
  }
  List<Product> get items{
    return [..._items];
  }
  List <Product> get favortiesItems{
    return _items.where((element) => element.isFavorite).toList();
  }
  Product findById(String id){
    return _items.firstWhere((ele) => ele.id==id);
  }
  List <Product> get good{
    return _items.where((element) => element.type=="electrical").toList();
  }
  List <Product> get good23{
    return _items.where((element) => element.type=="cars").toList();
  }
  List <Product> get good23t43{
    return _items.where((element) => element.type=="clothes").toList();
  }

  Future <void> fetchAndsetProducts([bool filterByUse=false]) async {
    final filterString=filterByUse ? 'orderBy="creatorId"&equalTo="$userId"':'';
    var url='https://shop-da072-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try{
      final res=await http.get(Uri.parse(url));
      final extractedDate=json.decode(res.body) as Map <String,dynamic>;
      if(extractedDate==null){
        return ;
      }
      url='https://shop-da072-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favRes=await http.get(Uri.parse(url));
      final favoDate=json.decode(favRes.body);
      final List <Product> loadProducts=[];
      extractedDate.forEach((prodId, prodDate) {
        loadProducts.add(Product(
          id: prodId,
          title: prodDate['title'],
          descrption: prodDate['descrption'],
          price: prodDate['price'],
          imageUrl: prodDate['imageUrl'],
          type: prodDate['type'],
          isFavorite:favoDate==null?false :favoDate[prodId] ?? false,
        ));
      });
      _items=loadProducts;
      notifyListeners();
    }
    catch(e){
      throw e;
    }
  }
  Future<void> addProduct(Product product)async{
    final url='https://shop-da072-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try{
      final res=await http.post(Uri.parse(url),body: json.encode({
        'title':product.title,
        'descrption':product.descrption,
        'imageUrl':product.imageUrl,
        'type':product.type,
        'price':product.price,
        'creatorId':userId
      }));
      final newProduct=Product(
        id: json.decode(res.body)['name'],
        title:product.title,
        descrption:product.descrption,
        imageUrl:product.imageUrl,
        type: product.type,
        price:product.price,
      );
      // .add(newProduct);
      _items.add(newProduct);
      notifyListeners();
    }
    catch(e){
      throw e;
    }
  }
  Future <void> updateProduct(String id,Product newProduct) async{
    final prodIndex=_items.indexWhere((prod) => prod.id==id);
    if(prodIndex >=0){
      final url='https://shop-da072-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url),body: json.encode({
        'title':newProduct.title,
        'descrption':newProduct.descrption,
        'imageUrl':newProduct.imageUrl,
        'price':newProduct.price,
      }));
      _items[prodIndex]=newProduct;
      notifyListeners();
    }
    else{
      print("...");
    }
  }
  Future <void> deleteProduct(String id) async{
    final url='https://shop-da072-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
    final exitingProductIndex=_items.indexWhere((prod) => prod.id==id);
    var exitingProduct=_items[exitingProductIndex];
    _items.removeAt(exitingProductIndex);
    notifyListeners();
    final res=await http.delete(Uri.parse(url));
    if(res.statusCode >= 400){
      _items.insert(exitingProductIndex, exitingProduct);
      notifyListeners();
      throw HttpExption('Could not delet product');
    }
    exitingProduct=null;
  }
}