import 'package:flutter/material.dart';

void main() {
  runApp(const Lab6App());
}

class Lab6App extends StatelessWidget {
  const Lab6App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ListPage(),
    );
  }
}

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final List<Map<String, dynamic>> _shoppingList = [];

  void _addItem() {
    String itemName = _itemController.text.trim();
    String qty = _quantityController.text.trim();

    if (itemName.isNotEmpty && qty.isNotEmpty) {
      setState(() {
        _shoppingList.add({'item': itemName, 'quantity': qty});
        _itemController.clear();
        _quantityController.clear();
      });
    }
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Item"),
        content:
        Text("Do you want to delete '${_shoppingList[index]['item']}'?"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _shoppingList.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping List")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _itemController,
                    decoration: const InputDecoration(
                      labelText: "Item name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: "Qty",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addItem,
                  child: const Text("Add"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // List Display
            Expanded(
              child: _shoppingList.isEmpty
                  ? const Center(
                child: Text(
                  "There are no items in the list",
                  style: TextStyle(fontSize: 16),
                ),
              )
                  : ListView.builder(
                itemCount: _shoppingList.length,
                itemBuilder: (context, index) {
                  final item = _shoppingList[index];
                  return GestureDetector(
                    onLongPress: () => _confirmDelete(index),
                    child: Card(
                      child: ListTile(
                        title: Text("${index + 1}. ${item['item']}"),
                        trailing: Text("Qty: ${item['quantity']}"),
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
