import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Pet Shop',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String category = 'All';
  final List<Map> pets = [
    {'name': 'Golden Retriever', 'cat': 'Dogs', 'price': 500, 'emo': '🐕'},
    {'name': 'Labrador', 'cat': 'Dogs', 'price': 450, 'emo': '🐕'},
    {'name': 'Persian Cat', 'cat': 'Cats', 'price': 300, 'emo': '🐈'},
    {'name': 'Siamese Cat', 'cat': 'Cats', 'price': 250, 'emo': '🐈'},
    {'name': 'Parrot', 'cat': 'Birds', 'price': 200, 'emo': '🦜'},
    {'name': 'Canary', 'cat': 'Birds', 'price': 100, 'emo': '🐦'},
    {'name': 'Pet Bed', 'cat': 'Accessories', 'price': 50, 'emo': '🛏️'},
    {'name': 'Food Bowl', 'cat': 'Accessories', 'price': 20, 'emo': '🥣'},
  ];

  final List<Map> cart = [];
  final cats = ['All', 'Dogs', 'Cats', 'Birds', 'Accessories'];

  @override
  Widget build(BuildContext c) {
    final items = category == 'All'
        ? pets
        : pets.where((p) => p['cat'] == category).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Shop'),
        actions: [
          IconButton(
            icon: Stack(children: [const Icon(Icons.shopping_cart), if (cart.isNotEmpty) Positioned(right: 0, child: CircleAvatar(radius: 8, backgroundColor: Colors.red, child: Text('${cart.length}', style: const TextStyle(fontSize: 10, color: Colors.white))))]),
            onPressed: _openCart,
          )
        ],
      ),
      body: Column(children: [
        SizedBox(height: 60, child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(8), children: cats.map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: ChoiceChip(label: Text(e), selected: category == e, onSelected: (_) => setState(() => category = e)))).toList())),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.78, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final p = items[i];
              return Card(
                child: Column(children: [
                  Container(height: 90, color: Colors.blue[50], child: Center(child: Text(p['emo'], style: const TextStyle(fontSize: 48)))),
                  Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(p['name'], style: const TextStyle(fontWeight: FontWeight.bold)), Text(p['cat'], style: const TextStyle(color: Colors.grey)), const SizedBox(height: 8), Text('\$${p['price']}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))])),
                  const Spacer(),
                  SizedBox(width: double.infinity, child: Row(children: [Expanded(child: TextButton(onPressed: () => _showDetail(p), child: const Text('View'))), Expanded(child: TextButton(onPressed: () => _addToCart(p), child: const Text('Add')))]))
                ]),
              );
            },
          ),
        )
      ]),
    );
  }

  void _addToCart(Map p) {
    setState(() => cart.add(p));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${p['name']} added')));
  }

  void _showDetail(Map p) {
    showModalBottomSheet(context: context, builder: (_) => Padding(padding: const EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Text(p['emo'], style: const TextStyle(fontSize: 40)), const SizedBox(width: 12), Expanded(child: Text(p['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)))]), const SizedBox(height: 12), Text('Category: ${p['cat']}'), Text('Price: \$${p['price']}'), const SizedBox(height: 12), ElevatedButton(onPressed: () { Navigator.pop(context); _addToCart(p); }, child: const Text('Add to cart'))])));
  }

  void _openCart() {
    showModalBottomSheet(context: context, builder: (_) => SizedBox(height: 400, child: Column(children: [Padding(padding: const EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text('Items: ${cart.length}') ])), Expanded(child: cart.isEmpty ? const Center(child: Text('Cart empty')) : ListView.separated(itemCount: cart.length, separatorBuilder: (_,__)=>const Divider(), itemBuilder: (_,i){ final it=cart[i]; return ListTile(title: Text(it['name']), subtitle: Text('\$${it['price']}'), trailing: IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => cart.removeAt(i)))); })), Padding(padding: const EdgeInsets.all(12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Total: \$${cart.fold(0, (s, e) => s + (e['price'] as num))}', style: const TextStyle(fontWeight: FontWeight.bold)), ElevatedButton(onPressed: () { final total = cart.fold(0, (s, e) => s + (e['price'] as num)); setState(() => cart.clear()); Navigator.pop(context); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed: \$$total'))); }, child: const Text('Checkout'))]))]));
  }
}
