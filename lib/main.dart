import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 3 Layouts',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Lab 3 Layouts'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  var isChecked = false;
  var myFontSize = 0.0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _incrementCounter() => setState(() => _counter++);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i) {},
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Camera'),
          BottomNavigationBarItem(icon: Icon(Icons.add_a_photo), label: 'Phone'),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const [
            DrawerHeader(child: Text('Menu')),
            ListTile(title: Text('Page 1')),
            ListTile(title: Text('Page 2')),
          ],
        ),
      ),
      appBar: AppBar(
        actions: [
          OutlinedButton(onPressed: () {}, child: Image.asset("images/algonquin.jpg", height: 32)),
          OutlinedButton(onPressed: () {}, child: const Text("Exit")),
        ],
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // SpaceBetween (rubric)
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //center text for browse category
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('BROWSE CATEGORIES', style: textStyle),
            ]),

            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Text('Not sure what you are looking for? Do a search or dive into popular categories'),
            ]),

            // 1/8 centered text
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('By Protein', style: textStyle),
            ]),

            // 2/8 images row with center labels
            _AvatarRow(items: const [
              _Item('Beef', 'Images/beef.jpg', _LabelPos.center),
              _Item('Chicken', 'Images/chicken.jpg', _LabelPos.center),
              _Item('Pork', 'Images/pork.jpg', _LabelPos.center),
              _Item('Seafood', 'Images/seafood.jpg', _LabelPos.center),
            ]),

            // 3/8 Center text
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('By Course', style: textStyle),
            ]),

            // 4/8 images row with bottom-center labels
            _AvatarRow(items: const [
              _Item('Main dishes', 'Images/maindish.jpg', _LabelPos.bottom),
              _Item('Salad Recipes', 'Images/salad.jpg', _LabelPos.bottom),
              _Item('Side Dishes', 'Images/sidedish.jpg', _LabelPos.bottom),
              _Item('Crockpot', 'Images/crockpot.jpg', _LabelPos.bottom),
            ]),

            // 5/8 centered text
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('By Dessert', style: textStyle),
            ]),

            // 6/8 images row with center labels
            _AvatarRow(items: const [
              _Item('Ice Cream', 'Images/ice-cream.jpg', _LabelPos.bottom),
              _Item('Brownies', 'Images/brownie.jpg', _LabelPos.bottom),
              _Item('Pies', 'Images/pie.jpg', _LabelPos.bottom),
              _Item('Cookies', 'Images/cookie.jpg', _LabelPos.bottom),
            ]),

            // 7/8 centered text
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('New & Popular', style: textStyle),
            ]),

            // 8/8 centered text
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('Find more in the search bar', style: textStyle),
            ]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}

enum _LabelPos { center, bottom }

class _Item {
  final String label;
  final String path;
  final _LabelPos pos;
  const _Item(this.label, this.path, this.pos);
}

class _AvatarRow extends StatelessWidget {
  final List<_Item> items;
  const _AvatarRow({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, // SpaceAround (rubric)
      children: items.map((e) => _AvatarTile(e)).toList(),
    );
  }
}

class _AvatarTile extends StatelessWidget {
  final _Item item;
  const _AvatarTile(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(item.path),
            radius: 42,
          ),
          Positioned(
            bottom: item.pos == _LabelPos.bottom ? 6 : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
