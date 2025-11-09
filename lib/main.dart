import 'package:flutter/material.dart';
import 'shopping_list_database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Home Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ShoppingListPage(),
      debugShowCheckedModeBanner: true,
    );
  }
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  // Controllers for the text fields
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  // List to store shopping items
  final List<ShoppingItem> _shoppingList = [];

  // Database instance
  final ShoppingDatabase _database = ShoppingDatabase.instance;

  @override
  void initState() {
    super.initState();
    // Load items from database when app starts
    _loadItems();
  }

  // Method to load items from database
  Future<void> _loadItems() async {
    final items = await _database.getAllItems();
    setState(() {
      _shoppingList.clear();
      _shoppingList.addAll(items);
    });
  }

  // Method to add item to the list and database
  Future<void> _addItem() async {
    String itemName = _itemController.text.trim();
    String quantityText = _quantityController.text.trim();

    if (itemName.isNotEmpty && quantityText.isNotEmpty) {
      int? quantity = int.tryParse(quantityText);
      if (quantity != null && quantity > 0) {
        // Create the item without an ID
        ShoppingItem newItem = ShoppingItem(name: itemName, quantity: quantity);

        // Insert into database and get the item with ID
        ShoppingItem insertedItem = await _database.insert(newItem);

        setState(() {
          _shoppingList.add(insertedItem);
          // Clear the text fields after adding
          _itemController.clear();
          _quantityController.clear();
        });
      }
    }
  }

  // Method to show delete confirmation dialog
  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: Text('Do you want to delete "${_shoppingList[index].name}"?'),
          actions: [
            TextButton(
              onPressed: () {
                // User selected "No" - just close the dialog
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // User selected "Yes" - remove the item
                _deleteItem(index);
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  // Method to delete item from list and database
  Future<void> _deleteItem(int index) async {
    final item = _shoppingList[index];

    // Delete from database if item has an ID
    if (item.id != null) {
      await _database.delete(item.id!);
    }

    setState(() {
      _shoppingList.removeAt(index);
    });
  }

  @override
  void dispose() {
    _itemController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input section
            Row(
              children: [
                // Item name text field
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      hintText: 'Type the item here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Quantity text field
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Type the quantity here',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Add button
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text('Click here'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // List section
            Expanded(
              child: _shoppingList.isEmpty
                  ? const Center(
                child: Text(
                  'There are no items in the list',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                itemCount: _shoppingList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onLongPress: () {
                      _showDeleteDialog(index);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}: ${_shoppingList[index].name}  quantity: ${_shoppingList[index].quantity}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}