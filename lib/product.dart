import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emartapp/userService.dart';

class Product {
  final String id;  // Use String for Firestore document IDs
  final String name;
  final String category;
  final String image;
  final String description;
  final double price;
  final int quantity;
  final List<dynamic>? colors;
  final List<dynamic>? sizes;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.description,
    required this.price,
    required this.quantity,
    required this.colors,
    required this.sizes,
  });

  // Factory method to create a Product from a Firestore document
  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'],
      category: data['category'],
      image: data['image'],
      description: data['description'],
      price: data['price'],
      quantity: data['quantity'],
      colors: data["colors"],
      sizes: data["sizes"],
    );
  }

  // Method to convert a Product to a Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'image': image,
      'description': description,
      'price': price,
      'quantity': quantity,
      'colors': colors,
      'sizes': sizes
    };
  }
}
