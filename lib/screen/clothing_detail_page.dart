import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/CartService.dart';

class ClothingDetailPage extends StatelessWidget {
  final Map<String, dynamic> item;

  const ClothingDetailPage({super.key, required this.item});

  Future<void> _addToCart(BuildContext context) async {
    try {
      // Ajouter au panier via CartService
      CartService.addItem({
        'id': DateTime.now().toString(),
        'titre': item['titre'],
        'marque': item['marque'],
        'categorie': item['categorie'],
        'prix': item['prix'],
        'taille': item['taille'],
        'image': item['image'],
      });

      // Afficher un message de succès
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produit ajouté au panier'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // En cas d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'ajout au panier: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['titre'] ?? 'Détails du produit'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                item['image'] ?? 'URL_image_par_defaut',
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, size: 50),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${item['marque']} - ${item['titre']}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Catégorie: ${item['categorie']}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Taille: ${item['taille']}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Prix: ${item['prix']}€',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addToCart(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Ajouter au panier',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
