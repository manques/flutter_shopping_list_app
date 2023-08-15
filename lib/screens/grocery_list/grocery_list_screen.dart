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
  var _isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
      'flutter-dummy-backend-default-rtdb.firebaseio.com',
      'flutter-shopping-list.json',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          error = 'Fail to fetch data. Please try again later!';
        });
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
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
      setState(() {
        _groceryList = loadedItem;
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        error = 'Something went wrong!. Please try again later.';
      });
    }
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
    Widget content;
    if (_groceryList.isEmpty) {
      content = const Center(
        child: Text('No Item add yet.'),
      );
    } else {
      content = ListView.builder(
        itemCount: _groceryList.length,
        itemBuilder: (ctx, index) => Dismissible(
          key: ValueKey(_groceryList[index].id),
          onDismissed: (direction) {
            _removeItem(_groceryList[index]);
          },
          child: ListTile(
            title: Text(_groceryList[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryList[index].category.color,
            ),
            trailing: Text(
              _groceryList[index].quantity.toString(),
            ),
          ),
        ),
      );
    }

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      content = Center(
        child: Text(error!),
      );
    }

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
      body: content,
    );
  }
}
