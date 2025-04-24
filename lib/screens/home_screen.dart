import 'package:flutter/material.dart';
import 'package:productos_app_flutter/screens/screens.dart';
import 'package:productos_app_flutter/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:productos_app_flutter/services/products_service.dart';

import '../models/product.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productsServices = Provider.of<ProductsServices>(context);

    if (productsServices.isLoading) {
      return LoadingScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      body: ListView.builder(
        itemCount: productsServices.products.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              productsServices.selectedProduct =
                  productsServices.products[index].copy();
              Navigator.pushNamed(context, 'product');
            },
            child: ProductCard(
              product: productsServices.products[index],
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          productsServices.selectedProduct =
              Product(available: true, name: '', price: 0.0);
          Navigator.pushNamed(context, 'product');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
