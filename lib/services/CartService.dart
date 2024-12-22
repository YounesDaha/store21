import 'package:cloud_firestore/cloud_firestore.dart';

class CartService {
  // Liste statique pour stocker temporairement les articles localement
  static final List<Map<String, dynamic>> _cartItems = [];

  // Identifiant de l'utilisateur (fixe pour le MVP, peut être récupéré dynamiquement ensuite)
  static const String userId = 'user123';

  // Firestore user reference
  static final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

  // Ajouter un article au panier (local et Firestore)
  static Future<void> addItem(Map<String, dynamic> item) async {
    // Ajouter localement
    _cartItems.add(item);

    try {
      // Vérifier si l'utilisateur existe
      final userDoc = await userRef.get();
      if (!userDoc.exists) {
        // Si l'utilisateur n'existe pas encore, créer un document vide avec un panier
        await userRef.set({'cart': []});
      }

      // Ajouter l'article au panier dans Firestore
      await userRef.update({
        'cart': FieldValue.arrayUnion([item])
      });
    } catch (e) {
      print('Erreur lors de l\'ajout à Firestore : $e');
    }
  }

  // Récupérer les articles du panier
  static Future<List<Map<String, dynamic>>> fetchCartItems() async {
    try {
      final userDoc = await userRef.get();
      if (userDoc.exists) {
        final cart = userDoc['cart'] as List<dynamic>? ?? [];
        return cart.map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (e) {
      print('Erreur lors de la récupération du panier : $e');
    }
    return [];
  }

  // Supprimer un article du panier par ID
  static Future<void> removeItem(Map<String, dynamic> item) async {
    _cartItems.remove(item);
    try {
      await userRef.update({
        'cart': FieldValue.arrayRemove([item])
      });
    } catch (e) {
      print('Erreur lors de la suppression de l\'article : $e');
    }
  }

  // Getter pour accéder aux articles en mémoire locale
  static List<Map<String, dynamic>> get cartItems => _cartItems;
}
