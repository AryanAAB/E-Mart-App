import 'package:emartapp/appbar.dart';
import 'package:emartapp/constants.dart';
import 'package:emartapp/product.dart';
import 'package:emartapp/productService.dart';
import 'package:emartapp/userService.dart';
import 'package:flutter/material.dart';

import 'navbar.dart';

class FavoritesPage extends StatefulWidget {
  List<String> favorites;
  List<Product> featuredProducts;
  UserService service;

  FavoritesPage(this.featuredProducts, this.favorites, this.service);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  List<String> favorites = [];
  List<Product> featuredProducts = [];
  late UserService service;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    favorites = widget.favorites;
    featuredProducts = widget.featuredProducts;
    service = widget.service;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFavoritePressed(int index) {
    setState(() {
      if(favorites.contains(featuredProducts[index].id)) {
        service.removeFromFavorites(featuredProducts[index].id);
        favorites.remove(featuredProducts[index].id);
      }
      else {
        service.addToFavorites(featuredProducts[index].id);
        favorites.add(featuredProducts[index].id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Favorite Products',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              SizedBox(height: 20),
              favorites.isEmpty
                  ? Center(
                child: Column(
                  children: [
                    FadeTransition(
                      opacity: _animation,
                      child: Icon(
                        Icons.favorite_border,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Your favorite items will appear here!",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Start adding some to see the magic happen.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.5),
                ),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/productDetail', arguments: featuredProducts[featuredProducts.indexWhere((Product p){return p.id == favorites[index];})]);
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Image.asset(
                                  featuredProducts[featuredProducts.indexWhere((Product p){return p.id == favorites[index];})].image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      featuredProducts[featuredProducts.indexWhere((Product p){return p.id == favorites[index];})].name,
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "\$" + featuredProducts[featuredProducts.indexWhere((Product p){return p.id == favorites[index];})].price.toStringAsFixed(2),
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _onFavoritePressed(index);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 1,
        onTap: (int index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          }
          else if(index == 2){
            Navigator.pushReplacementNamed(context, '/cart');
          }
        },
      ),
    );
  }
}
