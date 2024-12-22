import 'package:cloud_firestore/cloud_firestore.dart';

class Addservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Ajoute un vêtement dans Firestore
  Future<void> saveClothingItem({
    required String titre,
    required String marque,
    required String taille,
    required double prix,
    required String categorie,
    required String image,
  }) async {
    try {
      // Crée un objet de données pour le vêtement
      final clothingItem = {
        'titre': titre,
        'marque': marque,
        'taille': taille,
        'prix': prix,
        'categorie': categorie,
        'image': image,
        'createdAt': FieldValue.serverTimestamp(), // Ajout de la date et heure de création
      };

      // Envoie les données dans la collection Firestore
      await _firestore.collection('clothingItems').add(clothingItem);
      print("Vêtement ajouté avec succès !");
    } catch (e) {
      print("Erreur lors de l'ajout : $e");
      rethrow; // Permet de transmettre l'exception pour un traitement supplémentaire
    }
  }
}

