import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';

import 'class/Product.dart';
import 'log_manager.dart';

class MainPage extends StatelessWidget{
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const Text("Check Favourite"),
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            onPressed: (){
              Navigator.of(context).pushReplacementNamed("/favPage");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Consumer(
            builder: (context, ref, child) => Expanded(
              child: ListView.separated(
                  itemBuilder: (_, index) {
                    var product = ref
                        .read(productsChangeNotifierProvider)
                        .products[index];
                    return Slidable(
                      endActionPane: ActionPane(
                          extentRatio: 1 / 10,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) async {
                                List<String>? res = await showTextInputDialog(
                                    context: context,
                                    title: "Edit Product",
                                    message: "Edit your products details",
                                    textFields: [
                                      DialogTextField(
                                        hintText: "Product name",
                                        initialText: product.name,
                                      ),
                                      DialogTextField(
                                          hintText: "Product Price",
                                          initialText: product.price,
                                          keyboardType: TextInputType.number),
                                    ]);
                                if (res == null) return;
                                try {
                                  ref
                                      .read(productsChangeNotifierProvider)
                                      .changeProductInfo(
                                      product: product,
                                      name: res.first,
                                      price: res.last);
                                } on Exception catch (e) {
                                  LogManager.shared.logToConsole(e);
                                }
                              },
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Edit',
                            ),
                            SlidableAction(
                              onPressed: (_) {
                                ref
                                    .read(productsChangeNotifierProvider)
                                    .removeProduct(delProduct: product);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ]),
                      child: ListTile(
                        title: Text(product.name ?? ""),
                        subtitle: Text(product.price ?? ""),
                        trailing: product.isFav ?? false
                            ? IconButton(
                          icon: const Icon(Icons.favorite),
                          onPressed: () {
                            ref
                                .read(productsChangeNotifierProvider).removeFromFav(oldFavProduct: product);
                          },
                        )
                            : IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {
                            ref
                                .read(productsChangeNotifierProvider).addToFav(newFavProduct: product);
                          },
                        ),
                      ),
                    );
                  },
                  itemCount: ref
                      .watch(productsChangeNotifierProvider)
                      .products
                      .length,
                  separatorBuilder: (_, index) => const Divider()),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Consumer(
        builder: (context, ref, child) => FloatingActionButton.large(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
          onPressed: () async {
            List<String>? res = await showTextInputDialog(
                context: context,
                title: "Add Product",
                message: "Enter your products details",
                textFields: [
                  const DialogTextField(hintText: "Product name"),
                  const DialogTextField(
                      hintText: "Product Price",
                      keyboardType: TextInputType.number),
                ]);
            if (res == null) return;
            try {
              var newProduct = Product(
                  name: res.first,
                  isFav: false,
                  price: res.last,
                  uid: const Uuid().v1());
              ref
                  .read(productsChangeNotifierProvider)
                  .addProduct(newProduct: newProduct);
            } on Exception catch (e) {
              LogManager.shared.logToConsole(e);
            }
          },
          child: const Text(
            "Add new Product",
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

}