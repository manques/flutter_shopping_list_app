import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shopping_list_app/shared/data/categories_data.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_shopping_list_app/screens/new_item/new_item_screen.dart';
import 'package:flutter_shopping_list_app/shared/models/grocery_model.dart';

class GroceryListScreen extends StatefulWidget {
  const GroceryListScreen({super.key});

  @override
  State<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends State<GroceryListScreen> {
  List<Grocery> _groceryList = [];
  late Future<List<Grocery>> _loadedItem;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadedItem = _loadItems();
  }

  Future<List<Grocery>> _loadItems() async {
    final url = Uri.https(
      'flutter-dummy-backend-default-rtdb.firebaseio.com',
      'flutter-shopping-list.json',
    );
    final response = await http.get(url);
    if (response.statusCode >= 400) {
      throw Exception('Fail to fetch data. Please try again later!');
    }

    if (response.body == 'null') {
      return [];
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Grocery> loadedItem = [];
    for (final item in listData.entries) {
      final category = categoriesData.entries
          .firstWhere(
            (element) => element.value.title == item.value['category'],
          )
          .value;
      loadedItem.add(
        Grocery(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }
    return loadedItem;
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<Grocery>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );
    if (newItem == null) {
      return;
    }
    setState(() {
      _groceryList.add(newItem);
    });
  }

  void _removeItem(Grocery grocery) async {
    final index = _groceryList.indexOf(grocery);
    setState(() {
      _groceryList.remove(grocery);
    });

    final url = Uri.https(
      'flutter-dummy-backend-default-rtdb.firebaseio.com',
      'flutter-shopping-list/${grocery.id}.json',
    );
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      setState(() {
        _groceryList.insert(index, grocery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Your Grocery List',
        ),
        actions: [
          IconButton(
            onPressed: () {
              _addItem();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _loadedItem,
        builder: (context, snapshot) {
          // loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          // empty response
          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No items added yet.',
              ),
            );
          }
          // list
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (ctx, index) => Dismissible(
              key: ValueKey(snapshot.data![index].id),
              onDismissed: (direction) {
                _removeItem(snapshot.data![index]);
              },
              child: ListTile(
                title: Text(snapshot.data![index].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: snapshot.data![index].category.color,
                ),
                trailing: Text(
                  snapshot.data![index].quantity.toString(),
                ),
              ),
            ),
          );
          // list end
        },
      ),
    );
  }
}
