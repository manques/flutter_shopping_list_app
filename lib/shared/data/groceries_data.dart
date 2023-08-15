import 'package:flutter_shopping_list_app/shared/data/categories_data.dart';
import 'package:flutter_shopping_list_app/shared/models/categories_model.dart';
import 'package:flutter_shopping_list_app/shared/models/grocery_model.dart';

final groceriesData = [
  Grocery(
    id: 'G1',
    name: 'Milk',
    quantity: 1,
    category: categoriesData[Categories.diary]!,
  ),
  Grocery(
    id: 'G2',
    name: 'Bananas',
    quantity: 5,
    category: categoriesData[Categories.fruit]!,
  ),
  Grocery(
    id: 'G3',
    name: 'Beef Steak',
    quantity: 6,
    category: categoriesData[Categories.meat]!,
  ),
];
