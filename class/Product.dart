import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class Product {
  String? uid;
  String? name;
  bool? isFav;
  String? price;

  Product(
      {required this.uid,
      required this.name,
      required this.isFav,
      required this.price});

  void setName(String name) {
    this.name = name;
  }

  void setPrice(String price) {
    this.price = price;
  }
}

final productsChangeNotifierProvider =
    ChangeNotifierProvider<ProductsChangeNotifier>((ref) {
  var dummyProducts = List.generate(
      10,
      (index) => Product(
            uid: const Uuid().v1(),
            name: Faker().food.dish(),
            isFav: false,
            price: (Random().nextDouble() * 1000).toStringAsFixed(2),
          ));
  return ProductsChangeNotifier(dummyProducts, []);
});

class ProductsChangeNotifier extends ChangeNotifier {
  final List<Product> products;
  final List<Product> favProducts;

  ProductsChangeNotifier(this.products, this.favProducts);

  void addProduct({required Product newProduct}) {
    products.add(newProduct);
    notifyListeners();
  }

  void removeProduct({required Product delProduct}) {
    products.removeWhere((product) => product.uid == delProduct.uid);
    notifyListeners();
  }

  void addToFav({required Product newFavProduct}) {
    if (favProducts.any((Product element) => element.uid == newFavProduct.uid)) return;
    newFavProduct.isFav = true;
    favProducts.add(newFavProduct);
    notifyListeners();
  }

  void removeFromFav({required Product oldFavProduct}) {
    favProducts.any((Product element) {
      if (element.uid == oldFavProduct.uid) {
        favProducts.remove(element);
        oldFavProduct.isFav = false;
        notifyListeners();
        return true;
      } else {
        return false;
      }
    });
  }

  void changeProductInfo(
      {required Product product,
      required String? name,
      required String? price}) {
    if (name != null) product.setName(name);
    if (price != null) product.setPrice(price);
    notifyListeners();
  }
}
