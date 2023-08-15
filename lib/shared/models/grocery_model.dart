import 'package:flutter_shopping_list_app/shared/models/category_model.dart';

class Grocery {
  final String id;
  final String name;
  final int quantity;
  final Category category;

  Grocery({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });
}
