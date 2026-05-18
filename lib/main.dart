import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'data/product_data.dart';
import 'models/product.dart';
import 'pages/product_detail_page.dart';
import 'pages/cart_page.dart';
import 'pages/favorites_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mini Katalog',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> cart = [];
  List<int> favorites = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final cartString = prefs.getString("cart");
    if (cartString != null) {
      List decoded = jsonDecode(cartString);
      cart = decoded
          .map((id) => products.firstWhere((p) => p.id == id))
          .toList();
    }

    final favString = prefs.getString("favorites");
    if (favString != null) {
      favorites = List<int>.from(jsonDecode(favString));
    }

    setState(() {});
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("cart", jsonEncode(cart.map((e) => e.id).toList()));

    await prefs.setString("favorites", jsonEncode(favorites));
  }

  void addToCart(Product product) {
    setState(() {
      final exists = cart.any((p) => p.id == product.id);

      if (!exists) {
        cart.add(product);
        saveData();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Bu ürün zaten sepette!")));
      }
    });
  }

  void removeFromCart(Product product) {
    setState(() {
      cart.removeWhere((p) => p.id == product.id);
      saveData();
    });
  }

  void toggleFavorite(Product product) {
    setState(() {
      if (favorites.contains(product.id)) {
        favorites.remove(product.id);
      } else {
        favorites.add(product.id);
      }
      saveData();
    });
  }

  double getTotalPrice() {
    return cart.fold(0, (sum, item) {
      final price =
          double.tryParse(item.price.toString().replaceAll("\$", "")) ?? 0;
      return sum + price;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = products
        .where((p) => p.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mini Katalog"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.red),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoritesPage(
                    allProducts: products,
                    favorites: favorites,
                    toggleFavorite: toggleFavorite,
                    addToCart: addToCart,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      CartPage(cart: cart, removeFromCart: removeFromCart),
                ),
              );
            },
          ),

          
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "🛒 ${cart.length}",
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    "${getTotalPrice().toStringAsFixed(0)} \$",
                    style: const TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: "Ürün ara...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() => searchQuery = value);
              },
            ),

            const SizedBox(height: 10),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "https://wantapi.com/assets/banner.png",
                height: 140,
                width: double.infinity,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Text("Banner yüklenemedi");
                },
              ),
            ),

            Expanded(
              child: GridView.builder(
                itemCount: filtered.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final product = filtered[index];

                  return GestureDetector(
                    // ✅ DETAY SAYFASI FIX
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      icon: Icon(
                                        favorites.contains(product.id)
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: Colors.red,
                                        size: 18,
                                      ),
                                      onPressed: () => toggleFavorite(product),
                                    ),
                                  ],
                                ),

                                Text(
                                  "${product.price} \$",
                                  style: const TextStyle(color: Colors.green),
                                ),

                                const SizedBox(height: 6),

                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => addToCart(product),
                                    child: const Text("Sepete Ekle"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
