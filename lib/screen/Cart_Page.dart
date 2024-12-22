import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/CartService.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cart = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      isLoading = true;
    });
    final fetchedCart = await CartService.fetchCartItems();
    setState(() {
      cart = fetchedCart;
      isLoading = false;
    });
  }

  Future<void> _removeItem(Map<String, dynamic> item) async {
    await CartService.removeItem(item);
    await _loadCart(); // Recharger le panier après suppression
  }

  @override
  Widget build(BuildContext context) {
    final total = cart.fold<double>(
        0, (sum, item) => sum + (item['prix'] ?? 0)); // Calcul du total

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Panier'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Indicateur de chargement
          : cart.isEmpty
              ? const Center(
                  child: Text(
                    'Votre panier est vide.',
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          final item = cart[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  item['image'] ?? 'URL_image_par_defaut',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error),
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                '${item['titre']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'Taille: ${item['taille']} | Prix: ${item['prix']}€',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => _removeItem(item),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Total général: ${total.toStringAsFixed(2)}€',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}
