import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../cart.dart';
import 'detail.dart';
import '../data/product.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _future = _fetch();

  Future<List<Product>> _fetch() async {
    final res = await http.get(Uri.parse('https://dummyjson.com/products'));
    if (res.statusCode != 200) throw Exception('Gagal memuat produk');
    final data = jsonDecode(res.body);
    return (data['products'] as List).map((e) => Product.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halo, ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => CartPage(username: widget.username))),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Error: ${snap.error}'),
                TextButton(
                    onPressed: () => setState(() => _future = _fetch()),
                    child: const Text('Coba lagi')),
              ]),
            );
          }
          final products = snap.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) {
              final p = products[i];
              return ListTile(
                leading: Image.network(p.thumbnail, width: 56, height: 56),
                title: Text(p.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('\$${p.price.toStringAsFixed(2)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => DetailPage(
                            product: p, username: widget.username))),
              );
            },
          );
        },
      ),
    );
  }
}
