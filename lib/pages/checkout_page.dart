import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  final double totalPrice;

  const CheckoutPage({
    super.key,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.shopping_cart_checkout,
                size: 90,
                color: Colors.blue,
              ),

              const SizedBox(height: 25),

              const Text(
                "Toplam Tutar",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "${totalPrice.toStringAsFixed(2)} TL",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Sipariş Başarılı"),
                        content: const Text(
                          "Siparişiniz başarıyla oluşturuldu 🎉",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.popUntil(
                                context,
                                (route) => route.isFirst,
                              );
                            },
                            child: const Text("Tamam"),
                          )
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    "Siparişi Tamamla",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}