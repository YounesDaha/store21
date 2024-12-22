
import 'package:flutter/material.dart';
import 'package:flutter_application_2/screen/Cart_Page.dart';
import 'package:flutter_application_2/screen/User_Profile_Page.dart';
import 'package:flutter_application_2/screen/add_clothing_page.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screen/login_page.dart';
import 'screen/clothing_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Application de Connexion',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: FutureBuilder(
          future: FirebaseAuth.instance.authStateChanges().first,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return const ClothingListPage();
            } else {
              return const LoginPage();
            }
          },
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => const ClothingListPage(),
          '/user': (context) => const UserProfilePage(),
          '/cart' : (context) => const CartPage(),
          '/add': (context) => AddClothingItemScreen()

        },
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final List<Map<String, dynamic>> _cart = [];

  List<Map<String, dynamic>> get cart => List.unmodifiable(_cart);

  void addToCart(Map<String, dynamic> item) {
    _cart.add(item);
    notifyListeners();
  }

  void removeFromCart(Map<String, dynamic> item) {
    _cart.remove(item);
    notifyListeners();
  }
}
