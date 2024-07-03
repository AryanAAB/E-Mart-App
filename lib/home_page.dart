import 'package:emartapp/appbar.dart';
import 'package:emartapp/constants.dart';
import 'package:emartapp/product.dart';
import 'package:emartapp/productService.dart';
import 'package:emartapp/userService.dart';
import 'package:flutter/material.dart';

import 'navbar.dart';

class HomePage extends StatefulWidget {
  final List<List<Product>> featureProducts;
  List<String> favorites;
  UserService service;

  HomePage(this.featureProducts, this.favorites, this.service);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedIndex = 0;
  late List<bool> _selections;
  List<List<Product>> featuredProducts = [];
  List<String> favorites = [];
  late UserService service;

  @override
  void initState() {
    super.initState();
    featuredProducts = widget.featureProducts;
    favorites = widget.favorites;
    service = widget.service;
    _selections = List.generate(categories.length, (index) => index == 0);
  }

  void _onFavoritePressed(int index) {
    setState(() {
      if(favorites.contains(featuredProducts[_selectedIndex][index].id)) {
        service.removeFromFavorites(featuredProducts[_selectedIndex][index].id);
        favorites.remove(featuredProducts[_selectedIndex][index].id);
      }
      else {
        service.addToFavorites(featuredProducts[_selectedIndex][index].id);
        favorites.add(featuredProducts[_selectedIndex][index].id);
      }
    });
  }

  Widget _buildButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      print(service);
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
                    'Featured Products',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge,
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      children: List.generate(categories.length, (index) =>
                          _buildButton(categories[index])),
                      isSelected: _selections,
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex <
                              _selections.length; buttonIndex++) {
                            _selections[buttonIndex] = (buttonIndex == index);
                          }
                          _selectedIndex = index;
                          print(_selectedIndex);
                        });
                      },
                      borderRadius: BorderRadius.circular(8.0),
                      selectedColor: Theme
                          .of(context)
                          .colorScheme
                          .onInverseSurface,
                      fillColor: Theme
                          .of(context)
                          .colorScheme
                          .error,
                      borderColor: Colors.grey,
                      borderWidth: 2.0,
                      selectedBorderColor: Colors.grey,
                      splashColor: Colors.grey.withOpacity(0.5),
                      highlightColor: Colors.transparent,
                    ),
                  ),
                ),
                //SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery
                        .of(context)
                        .size
                        .width / (MediaQuery
                        .of(context)
                        .size
                        .height / 1.5),
                  ),
                  itemCount: featuredProducts[_selectedIndex].length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/productDetail',
                            arguments: featuredProducts[_selectedIndex][index]);
                      },
                      child: Card(
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image.asset(
                                    featuredProducts[_selectedIndex][index]
                                        .image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        featuredProducts[_selectedIndex][index]
                                            .name,
                                        style: TextStyle(fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "\$" +
                                            featuredProducts[_selectedIndex][index]
                                                .price.toStringAsFixed(2),
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
                                  favorites.contains(
                                      featuredProducts[_selectedIndex][index]
                                          .id) ? Icons.favorite : Icons
                                      .favorite_border,
                                  color: favorites.contains(
                                      featuredProducts[_selectedIndex][index]
                                          .id) ? Colors.red : Colors.grey,
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
          currentIndex: 0,
          onTap: (int index) {
            if (index == 1) {
              Navigator.pushReplacementNamed(context, '/favorites');
            }
            else if (index == 2) {
              Navigator.pushReplacementNamed(context, '/cart');
            }
          },
        ),
      );
  }
}