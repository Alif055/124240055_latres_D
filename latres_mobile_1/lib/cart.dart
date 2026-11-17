import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CartPage extends StatelessWidget {
  final String username;
  const CartPage({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('cart');
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box b, _) {
          final keys = b.keys
              .where((k) => (b.get(k) as Map)['username'] == username)
              .toList();
          if (keys.isEmpty) {
            return const Center(child: Text('Cart kosong'));
          }
          return ListView.builder(
            itemCount: keys.length,
            itemBuilder: (context, i) {
              final item = Map<String, dynamic>.from(b.get(keys[i]));
              return ListTile(
                leading: Image.network(item['thumbnail'], width: 56, height: 56),
                title: Text(item['title']),
                subtitle: Text(
                    'Qty: ${item['qty']}  •  \$${(item['price'] * item['qty']).toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => b.delete(keys[i]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
