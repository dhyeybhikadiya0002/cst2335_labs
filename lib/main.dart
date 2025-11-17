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
  // TEST W8-UI-01:
  // • Typing in _itemController and clearing it should not crash.
  // • Empty item name + any quantity should NOT add an item.
  final TextEditingController _itemController = TextEditingController();

  // TEST W8-UI-02:
  // • _quantityController should accept only numbers for valid add.
  // • Non-numeric or <= 0 quantity should NOT add an item.
  final TextEditingController _quantityController = TextEditingController();

  // TEST W8-UI-03:
  // • _shoppingList must mirror DB content after _loadItems().
  // • After add/delete, list length should match expected item count.
  final List<ShoppingItem> _shoppingList = [];

  // TEST W8-DB-LINK-01:
  // • _database instance should be reused (singleton).
  // • All DB operations (getAllItems / insert / delete) must succeed without error.
  final ShoppingDatabase _database = ShoppingDatabase.instance;

  @override
  void initState() {
    super.initState();
    // TEST W8-INIT-01:
    // • On app start, _loadItems() is called.
    // • Items from DB should appear in list view.
    _loadItems();
  }

  // Method to load items from database
  // TEST W8-LOAD-01:
  // • With empty DB → _shoppingList becomes empty; "There are no items in the list" is shown.
  // • With pre-populated DB → all items displayed with correct name and quantity.
  Future<void> _loadItems() async {
    final items = await _database.getAllItems();
    setState(() {
      _shoppingList.clear();
      _shoppingList.addAll(items);
    });
  }

  // Method to add item to the list and database
  // TEST W8-ADD-01: itemName empty, quantity empty → no item added.
  // TEST W8-ADD-02: itemName non-empty, quantity empty → no item added.
  // TEST W8-ADD-03: itemName non-empty, quantity non-numeric → no item added.
  // TEST W8-ADD-04: itemName non-empty, quantity "0" or negative → no item added.
  // TEST W8-ADD-05: itemName non-empty, quantity valid positive int → item added to DB and list; fields cleared.
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
          // TEST W8-ADD-06:
          // • After successful add: both text fields should be cleared.
          _itemController.clear();
          _quantityController.clear();
        });
      }
    }
  }

  // Method to show delete confirmation dialog
  // TEST W8-DEL-01:
  // • Long-press on a list item opens this dialog.
  // • The dialog text includes the correct item name.
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
                // TEST W8-DEL-02:
                // • Pressing "No" should close dialog and NOT change the list.
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // TEST W8-DEL-03:
                // • Pressing "Yes" should remove the item from DB and UI.
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
  // TEST W8-DEL-04:
  // • After delete, list length decreases by 1 and the deleted name is gone.
  // • When last item is deleted, empty message is shown.
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
        // TEST W8-UI-00:
        // • AppBar should render without errors on startup.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input section
            Row(
              children: [
                // Item name text field
                // TEST W8-UI-04:
                // • Typing a normal string here, then tapping "Click here" with valid quantity
                //   should add a new list item.
                // • Leaving this field empty should prevent adding.
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
                // TEST W8-UI-05:
                // • With keyboardType number: numeric input accepted.
                // • Entering non-numeric text and pressing "Click here" should NOT add an item.
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
                // TEST W8-BTN-01:
                // • Single tap → calls _addItem().
                // • Double-tap quickly → no crash; adds at most one valid record per valid state.
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
                // TEST W8-LIST-01:
                // • When there are 0 items (after startup or after deleting last item),
                //   this text should be visible.
              )
                  : ListView.builder(
                itemCount: _shoppingList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    // TEST W8-GESTURE-01:
                    // • Long-press on any row should open delete dialog with that item.
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
