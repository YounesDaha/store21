import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  String _login = '';
  String _password = '********'; // Placeholder pour le mot de passe

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = _auth.currentUser;

    if (user != null) {
      setState(() {
        _login = user.email ?? '';
      });

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          _birthdayController.text = data['birthday'] ?? '';
          _addressController.text = data['address'] ?? '';
          _postalCodeController.text = data['postalCode'] ?? '';
          _cityController.text = data['city'] ?? '';
        });
      }
    }
  }

  Future<void> _saveUserProfile() async {
    final user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'birthday': _birthdayController.text,
        'address': _addressController.text,
        'postalCode': _postalCodeController.text,
        'city': _cityController.text,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès')),
      );
    }
  }

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _navigateToAddClothingPage() {
    Navigator.pushNamed(context, '/add');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil utilisateur'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Login',
                border: const OutlineInputBorder(),
                hintText: _login,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                hintText: '********',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _birthdayController,
              decoration: const InputDecoration(
                labelText: 'Anniversaire',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Adresse',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _postalCodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Code postal',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Ville',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveUserProfile,
              child: const Text('Valider'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _navigateToAddClothingPage,
              child: const Text('Ajouter un vêtement'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _logout,
              child: const Text(
                'Se déconnecter',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
