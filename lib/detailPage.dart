import 'package:emartapp/constants.dart';
import 'package:emartapp/product.dart';
import 'package:emartapp/product.dart';
import 'package:emartapp/userService.dart';
import 'package:flutter/material.dart';
import 'package:emartapp/appbar.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  final UserService service;
  Map<String, int> cart;

  DetailPage({Key? key, required this.product, required this.service, required this.cart}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {

  Color _colorFromHex(dynamic hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          leadingWidget:IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
            Navigator.pop(context);
            },
          )
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                widget.product.image,
                fit: BoxFit.scaleDown,
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                widget.product.name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Text(
                '\$' + widget.product.price.toStringAsFixed(2),
                style: TextStyle(fontSize: 20, color: Colors.green),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                widget.product.description,
                style: TextStyle(fontSize: 20, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16),
            if (widget.product.sizes != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sizes:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: (widget.product.sizes as List<dynamic>)
                        .map((size) => Chip(
                      label: Text(
                        size,
                        style: TextStyle(fontSize: 16),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                    ))
                        .toList(),
                  ),
                ],
              ),
            SizedBox(height: 16),
            if (widget.product.colors != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Colors:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Wrap(
                    spacing: 8.0,
                    children: (widget.product.colors as List<dynamic>)
                        .map((color) => Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: _colorFromHex(color),
                        shape: BoxShape.circle,
                      ),
                    ))
                        .toList(),
                  ),
                ],
              ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$' + widget.product.price.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        widget.service.addToCart(widget.product.id);
                        if(!widget.cart.containsKey(widget.product.id))
                          widget.cart[widget.product.id] = 1;
                        printMessage(context,
                            "Successfully added ${widget.product.name} to the cart.");
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

}
