import 'dart:typed_data';

import 'package:emartapp/product.dart';
import 'package:emartapp/productService.dart';
import 'package:flutter/material.dart';
import 'dart:math';

printError(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
          color: Theme.of(context).colorScheme.onError,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onErrorContainer,
    ),
  );
}

printMessage(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: TextStyle(
          fontSize: 20.0,
          color: Theme.of(context).colorScheme.onTertiary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      duration: Duration(seconds: 2),
    ),
  );
}

const categories = ["All Products", "Electronics", "Clothing", "Groceries"];