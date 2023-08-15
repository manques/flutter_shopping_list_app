import 'package:flutter/material.dart';
import 'package:flutter_shopping_list_app/core/theme/theme.dart';
import 'package:flutter_shopping_list_app/screens/grocery_list/grocery_list_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const GroceryListScreen(),
    );
  }
}
