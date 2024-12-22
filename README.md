# flutter_application_2

pplication E-commerce de Vêtements
Une application mobile e-commerce développée avec Flutter et Firebase, intégrant un modèle de classification d'images CNN pour la catégorisation automatique des vêtements.
Fonctionnalités principales
1. Authentification

Interface de connexion sécurisée
Champs de saisie : login et mot de passe (masqué)
Compte de démonstration :

Email : y@h.com
Mot de passe : 123456



2. Catalogue de Vêtements

Liste scrollable des vêtements disponibles
Affichage pour chaque article :

Image du produit
Titre
Taille
Prix


Navigation fluide vers les détails

3. Détails des Produits

Vue détaillée comprenant :

Image haute résolution
Titre
Catégorie (Pantalon, Short, Haut, etc.)
Taille
Marque
Prix


Fonctionnalités :

Bouton de retour à la liste
Option d'ajout au panier



4. Gestion du Panier

Vue d'ensemble des articles sélectionnés
Pour chaque article :

Image miniature
Titre
Taille
Prix


Calcul automatique du total
Suppression facile d'articles avec mise à jour instantanée

5. Profil Utilisateur

Consultation et modification des informations personnelles :

Login (lecture seule)
Mot de passe (masqué)
Date de naissance
Adresse complète
Code postal (validation numérique)
Ville


Options :

Sauvegarde des modifications
Déconnexion



6. Ajout de Produits avec IA

Interface d'ajout de nouveaux vêtements
Classification automatique par IA :

Modèle CNN personnalisé
Catégories supportées :

Pants (Pantalons)
Shirt (Chemises)
Shoes (Chaussures)
Shorts
Sneakers (Baskets)
T-shirt




Formulaire complet :

Upload d'image
Titre
Catégorie (définie automatiquement par l'IA)
Taille
Marque
Prix (validation numérique)



Technologies Utilisées

Frontend : Flutter
Backend : Firebase
IA : TensorFlow Lite (modèle CNN entraîné sur Kaggle)
IDE : Visual Studio Code

Navigation
L'application utilise une BottomNavigationBar avec trois sections principales :

Acheter (Catalogue)
Panier
Profil
