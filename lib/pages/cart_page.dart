import 'package:flutter/material.dart';
import '../models/product.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  final List<Product> cart;
  final Function(Product) removeFromCart;

  const CartPage({
    super.key,
    required this.cart,
    required this.removeFromCart,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get totalPrice {
    double total = 0;
    for (var item in widget.cart) {
      total += item.price;
    }
    return total;
  }

  void deleteItem(Product product) {
    widget.removeFromCart(product);

    // 🔥 UI anında güncellensin
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sepetim"),
      ),
      body: widget.cart.isEmpty
          ? const Center(
              child: Text(
                "Sepet boş",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final product = widget.cart[index];

                      return ListTile(
                        leading: Image.network(
                          product.imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(product.name),
                        subtitle: Text("${product.price} TL"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            deleteItem(product);
                          },
                        ),
                      );
                    },
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  color: Colors.blue.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Toplam: ${totalPrice.toStringAsFixed(2)} TL",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  totalPrice: totalPrice,
                                ),
                              ),
                            );
                          },
                          child: const Text("Siparişi Tamamla"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}