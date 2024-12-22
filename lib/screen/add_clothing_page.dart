import 'package:flutter/material.dart'; 
import '../services/AddService.dart';

class AddClothingItemScreen extends StatefulWidget {
  @override
  _AddClothingItemScreenState createState() => _AddClothingItemScreenState();
}

class _AddClothingItemScreenState extends State<AddClothingItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addService = Addservice();

  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  Future<void> _saveClothingItem() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _addService.saveClothingItem(
          titre: _titleController.text,
          categorie: _categoryController.text,
          taille: _sizeController.text,
          marque: _brandController.text,
          prix: double.parse(_priceController.text),
          image: _imageUrlController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vêtement ajouté avec succès !")),
        );
        _formKey.currentState!.reset();
        setState(() {
          _imageUrlController.clear();
          _titleController.clear();
          _categoryController.clear();
          _sizeController.clear();
          _brandController.clear();
          _priceController.clear();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Veuillez remplir tous les champs.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter un nouveau vêtement")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _imageUrlController,
                  decoration: InputDecoration(labelText: "URL de l'image"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Ce champ est obligatoire"
                      : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Titre"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Ce champ est obligatoire"
                      : null,
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: "Catégorie (ex: Pantalon, Short)"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Ce champ est obligatoire"
                      : null,
                ),
                TextFormField(
                  controller: _sizeController,
                  decoration: InputDecoration(labelText: "Taille"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Ce champ est obligatoire"
                      : null,
                ),
                TextFormField(
                  controller: _brandController,
                  decoration: InputDecoration(labelText: "Marque"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Ce champ est obligatoire"
                      : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: "Prix"),
                  keyboardType: TextInputType.number,
                  validator: (value) => value == null ||
                          double.tryParse(value) == null
                      ? "Veuillez entrer un prix valide"
                      : null,
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveClothingItem,
                    child: Text("Valider"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
