import 'package:flutter/material.dart';
import '../models/product.dart';

class FavoritesPage extends StatelessWidget {
  final List<Product> allProducts;
  final List<int> favorites;
  final Function(Product) toggleFavorite;
  final Function(Product) addToCart;

  const FavoritesPage({
    super.key,
    required this.allProducts,
    required this.favorites,
    required this.toggleFavorite,
    required this.addToCart,
  });

  @override
  Widget build(BuildContext context) {
    final favProducts = allProducts
        .where((p) => favorites.contains(p.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoriler ❤️"),
      ),
      body: favProducts.isEmpty
          ? const Center(
              child: Text("Henüz favori ürün yok"),
            )
          : ListView.builder(
              itemCount: favProducts.length,
              itemBuilder: (context, index) {
                final product = favProducts[index];

                return ListTile(
                  leading: Image.network(
                    product.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text("${product.price} TL"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          addToCart(product);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () {
                          toggleFavorite(product);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}