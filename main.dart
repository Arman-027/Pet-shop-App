import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Pet Shop',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pets = [
    {'name': 'Golden Retriever', 'cat': 'Dogs', 'price': 50000, 'emo': '🐕', 'desc': 'Friendly & energetic'},
    {'name': 'Labrador', 'cat': 'Dogs', 'price': 45000, 'emo': '🐕', 'desc': 'Loyal & intelligent'},
    {'name': 'Persian Cat', 'cat': 'Cats', 'price': 30000, 'emo': '🐈', 'desc': 'Calm & gentle'},
    {'name': 'Siamese Cat', 'cat': 'Cats', 'price': 25000, 'emo': '🐈', 'desc': 'Vocal & social'},
    {'name': 'African Grey', 'cat': 'Birds', 'price': 15000, 'emo': '🦜', 'desc': 'Highly intelligent'},
    {'name': 'Budgie', 'cat': 'Birds', 'price': 3000, 'emo': '🐦', 'desc': 'Small & colorful'},
    {'name': 'Pet Bed', 'cat': 'Accessories', 'price': 3000, 'emo': '🛏️', 'desc': 'Orthopedic foam'},
    {'name': 'Food Bowl', 'cat': 'Accessories', 'price': 1000, 'emo': '🥣', 'desc': 'Stainless steel'},
  ];

  List<Map> cart = [];
  String category = 'All';
  final cats = ['All', 'Dogs', 'Cats', 'Birds', 'Accessories'];

  @override
  Widget build(BuildContext context) {
    final filtered = category == 'All'
        ? pets
        : pets.where((p) => p['cat'] == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🐾 Pet Shop'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _openCart,
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text('${cart.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                )
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: cats.map((c) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ChoiceChip(
                  label: Text(c),
                  selected: category == c,
                  onSelected: (_) => setState(() => category = c),
                ),
              )).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filtered.length,
              itemBuilder: (ctx, i) {
                var pet = filtered[i];
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                          ),
                          child: Center(child: Text(pet['emo'], style: const TextStyle(fontSize: 48))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pet['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                            Text(pet['desc'], style: TextStyle(fontSize: 10, color: Colors.grey[600]), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Text('₹${pet['price']}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Expanded(child: TextButton(onPressed: () => _showDetail(pet), child: const Text('View', style: TextStyle(fontSize: 11)))),
                                Expanded(child: ElevatedButton(onPressed: () => _addToCart(pet), child: const Text('Add', style: TextStyle(fontSize: 11)))),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(Map pet) {
    setState(() => cart.add(pet));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${pet['name']} added!'), duration: const Duration(seconds: 1)),
    );
  }

  void _showDetail(Map pet) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text(pet['emo'], style: const TextStyle(fontSize: 60))),
            const SizedBox(height: 12),
            Text(pet['name'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Chip(label: Text(pet['cat'])),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category: ${pet['cat']}', style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text('Description: ${pet['desc']}', style: const TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₹${pet['price']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('Add'),
                  onPressed: () {
                    _addToCart(pet);
                    Navigator.pop(context);
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _openCart() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      builder: (_) => SizedBox(
        height: 400,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('🛒 Shopping Cart', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: cart.isEmpty
                  ? const Center(child: Text('Cart is empty'))
                  : ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (_, i) => ListTile(
                        leading: Text(cart[i]['emo'], style: const TextStyle(fontSize: 28)),
                        title: Text(cart[i]['name']),
                        subtitle: Text('₹${cart[i]['price']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => setState(() => cart.removeAt(i)),
                        ),
                      ),
                    ),
            ),
            if (cart.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('₹${cart.fold(0, (sum, item) => sum + item['price'])}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final total = cart.fold(0, (sum, item) => sum + item['price']);
                          setState(() => cart.clear());
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(' Order placed! Total: ₹$total'), backgroundColor: Colors.green),
                          );
                        },
                        child: const Text('Place Order'),
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

