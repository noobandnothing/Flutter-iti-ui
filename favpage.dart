import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'class/Product.dart';

class FavPage extends StatelessWidget{
  const FavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          const Text("Return"),
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            onPressed: (){
              Navigator.of(context).pushReplacementNamed("/");
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
                        .favProducts[index];
                    return Slidable(
                      endActionPane: ActionPane(
                          extentRatio: 1 / 10,
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (_) {
                                ref
                                    .read(productsChangeNotifierProvider)
                                    .removeFromFav(oldFavProduct: product);
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
                      .favProducts
                      .length,
                  separatorBuilder: (_, index) => const Divider()),
            ),
          ),
        ],
      ),
    );
  }

}