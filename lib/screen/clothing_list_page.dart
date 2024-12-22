import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/screen/User_Profile_Page.dart';
import 'clothing_detail_page.dart';
import 'Cart_Page.dart';

class ClothingListPage extends StatefulWidget {
  const ClothingListPage({super.key});

  @override
  State<ClothingListPage> createState() => _ClothingListPageState();
}

class _ClothingListPageState extends State<ClothingListPage> {
  int _currentIndex = 0;

  // Ajout d'un Widget pour gérer les différentes pages
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return _buildBody();
      case 1:
        return const CartPage();
      case 2:
        return const UserProfilePage();
      default:
        return _buildBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0 
          ? 'Acheter des vêtements' 
          : _currentIndex == 1 
            ? 'Mon Panier' 
            : 'Mon Profil'
        ),
      ),
      body: _getPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        // onTap: (index) {
        //   setState(() {
        //     _currentIndex = index;
        //   });

        //   if (index == 2) {
        //     Navigator.pushNamed(context, '/user');
        //   }
        // },


        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('clothes').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Aucun vêtement disponible pour le moment.'));
        }

        final clothes = snapshot.data!.docs;

        return ListView.builder(
          itemCount: clothes.length,
          itemBuilder: (context, index) {
            final item = clothes[index];
            final data = item.data() as Map<String, dynamic>;

            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    data['image'] ?? 'URL_image_par_defaut',
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
                  data['titre'] ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Taille: ${data['taille']} | Prix: ${data['prix']}€'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClothingDetailPage(item: data),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}