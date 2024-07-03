import 'package:emartapp/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  // Add to favorites
  Future<void> addToFavorites(String productId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await userCollection.doc(user.uid).update({
        'favorites': FieldValue.arrayUnion([productId])
      });
    }
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String productId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await userCollection.doc(user.uid).update({
        'favorites': FieldValue.arrayRemove([productId])
      });
    }
  }

  // Add to cart
  Future<void> addToCart(String productId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await userCollection.doc(user.uid).get();
      Map<String, int> cart = Map<String, int>.from(doc['cart']);
      cart[productId] = 1;
      await userCollection.doc(user.uid).update({
        'cart': cart
      });
    }
  }

  Future<void> set(String productId, int count) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await userCollection.doc(user.uid).get();
      Map<String, int> cart = Map<String, int>.from(doc['cart']);
      if(cart.containsKey(productId))
        cart[productId] = count;
      await userCollection.doc(user.uid).update({
        'cart': cart
      });
    }
  }

// Remove from cart
  Future<void> removeFromCart(String productId) async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await userCollection.doc(user.uid).get();
      Map<String, int> cart = Map<String, int>.from(doc['cart']);
      if (cart.containsKey(productId)) {
        cart.remove(productId);
        await userCollection.doc(user.uid).update({
          'cart': cart
        });
      }
    }
  }

  // Fetch user favorites
  Future<List<String>> fetchFavorites() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await userCollection.doc(user.uid).get();
      List<String> favorites = List<String>.from(doc['favorites']);
      return favorites;
    }
    return [];
  }

  // Fetch user cart
  Future<Map<String, int>> fetchCart() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await userCollection.doc(user.uid).get();
      Map<String, int> cart = Map<String, int>.from(doc['cart']);
      return cart;
    }
    return {};
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }
}