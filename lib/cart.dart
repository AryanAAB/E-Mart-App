import 'package:emartapp/appbar.dart';
import 'package:emartapp/navbar.dart';
import 'package:emartapp/product.dart';
import 'package:emartapp/userService.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  List<Product> featuredProducts;
  Map<String, int> cart;
  UserService service;

  CartPage(this.featuredProducts, this.cart, this.service);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Product> featuredProducts;
  late Map<String, int> cart;
  late UserService service;

  @override
  void initState() {
    super.initState();

    featuredProducts = widget.featuredProducts;
    cart = widget.cart;
    service = widget.service;
  }

  @override
  Widget build(BuildContext context) {
    double cost = 0;
    cart.forEach((key, value) {
      bool test(Product p){
        return p.id == key;
      }
      cost += featuredProducts[featuredProducts.indexWhere(test)].price * value;
    });
    final cartEntries = cart.entries.toList();

    return Scaffold(
      appBar: CustomAppBar(),
      body: cart.length == 0
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 200, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Your cart is empty.\nStart shopping now!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 35, color: Colors.grey),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.8,
              ),
              itemCount: cartEntries.length,
              itemBuilder: (context, index) {
                final entry = cartEntries[index];
                Product product = featuredProducts[featuredProducts.indexWhere((Product p) {return p.id == entry.key;})];
                int count = entry.value;

                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      service.removeFromCart(entry.key);
                      cart.remove(entry.key);
                    });
                  },
                  child: Card(
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Image.asset(
                              product.image,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(product.name,
                              style: TextStyle(fontSize: 25)),
                          SizedBox(height: 4),
                          Text('\$${product.price}',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (count > 1) {
                                      cart[entry.key] = count - 1;
                                      service.set(entry.key, cart[entry.key]!);
                                    }
                                  });
                                },
                              ),
                              Text(
                                  '$count',
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    cart[entry.key] = count + 1;
                                    service.set(entry.key, cart[entry.key]!);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Cost:',
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$' + cost.toStringAsFixed(2),
                  style:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: 2,
        onTap: (int index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/favorites');
          } else if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
      ),
    );
  }
}
