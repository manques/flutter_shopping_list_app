import 'package:flutter/material.dart';
import 'package:flutter_shopping_list_app/shared/models/category_model.dart';
import 'package:flutter_shopping_list_app/shared/models/categories_model.dart';

const categoriesData = {
  Categories.vegatables: Category(
    title: 'Vegtables',
    color: Colors.greenAccent,
  ),
  Categories.fruit: Category(
    title: 'Fruit',
    color: Colors.limeAccent,
  ),
  Categories.meat: Category(
    title: 'Meat',
    color: Colors.blue,
  ),
  Categories.diary: Category(
    title: 'Diary',
    color: Colors.brown,
  ),
  Categories.carbs: Category(
    title: 'Carbs',
    color: Colors.grey,
  ),
  Categories.sweets: Category(
    title: 'Sweets',
    color: Color.fromARGB(255, 240, 105, 226),
  ),
  Categories.spices: Category(
    title: 'Spices',
    color: Color.fromARGB(255, 255, 109, 65),
  ),
  Categories.convenience: Category(
    title: 'Convenience',
    color: Color.fromARGB(255, 184, 243, 33),
  ),
  Categories.hygiene: Category(
    title: 'Hygiene',
    color: Color.fromARGB(255, 218, 174, 158),
  ),
  Categories.other: Category(
    title: 'Other',
    color: Color.fromARGB(255, 83, 26, 70),
  ),
};
