import 'package:emartapp/detailPage.dart';
import 'package:emartapp/cart.dart';
import 'package:emartapp/favorites.dart';
import 'package:emartapp/login_page.dart';
import 'package:emartapp/open_page.dart';
import 'package:emartapp/home_page.dart';
import 'package:emartapp/product.dart';
import 'package:emartapp/productService.dart';
import 'package:emartapp/userService.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'constants.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late Future<List<List<Product>>> featureProducts;
  late Future<List<String>> favorites;
  late Future<Map<String, int>> cart;
  UserService service = UserService();

  MyApp() {reset();}

  void reset(){
    _loadFeaturedProducts();
    _loadFavorites();
    _loadCart();
  }

  Future<void> _loadFeaturedProducts() async {
    ProductService service = ProductService();
    List<Product> product = await service.fetchProducts();
    List<List<Product>> products = [];
    products.add(product);
    for(int i = 1; i < categories.length; i++) {
      products.add(await service.fetchProductsByCategory(categories[i]));
    }

    featureProducts = Future.value(products);
  }

  Future<void> _loadCart() async {
    Map<String, int> products = await service.fetchCart();
    cart = Future.value(products);
  }

  Future<void> _loadFavorites() async {
    List<String> products = await service.fetchFavorites();
    favorites = Future.value(products);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'E-MartApp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        initialRoute: '/open',
        routes: {
          '/open': (context) => OpenPage(),
          '/login': (context) => LoginPage(app:this),
          '/signUp': (context) => SignUpPage(app:this),
          '/home': (context) =>
              FutureBuilder(
                future: Future.wait([featureProducts, favorites]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return Scaffold(
                        body: Center(child: Text('Error loading data')));
                  } else {
                    List<List<Product>> products = snapshot.data![0];
                    List<String> favs = snapshot.data![1];
                    return HomePage(products, favs, service);
                  }
                },
              ),
          '/favorites': (context) =>
              FutureBuilder(
                future: Future.wait([featureProducts, favorites]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return Scaffold(
                        body: Center(child: Text('Error loading data')));
                  } else {
                    List<List<Product>> products = snapshot.data![0];
                    List<String> favs = snapshot.data![1];
                    return FavoritesPage(products[0], favs, service);
                  }
                },
              ),
          '/productDetail': (context) => FutureBuilder(
            future: Future.wait([cart]),
            builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Error loading data')));
            } else {
              Map<String, int> cart = snapshot.data![0];
              return DetailPage(product: ModalRoute.of(context)!.settings.arguments as Product, service: service, cart: cart);
            }
            }
          ),
          '/cart': (context) =>
              FutureBuilder(
                future: Future.wait([featureProducts, cart]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                        body: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return Scaffold(
                        body: Center(child: Text('Error loading data')));
                  } else {
                    List<List<Product>> products = snapshot.data![0];
                    Map<String, int> cart = snapshot.data![1];
                    return CartPage(products[0], cart, service);
                  }
                },
              ),
        }
    );
  }
}
