import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/product.dart';

class DetailPage extends StatefulWidget {
  final Product product;
  final String username;
  const DetailPage({super.key, required this.product, required this.username});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _qty = 1;

  void _addToCart() {
    final p = widget.product;
    // Key unik per user + produk, jadi cart tiap user terpisah
    Hive.box('cart').put('${widget.username}|${p.id}', {
      'username': widget.username,
      'productId': p.id,
      'title': p.title,
      'thumbnail': p.thumbnail,
      'price': p.price,
      'qty': _qty,
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ditambahkan ke keranjang')));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        SizedBox(
          height: 220,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: (p.images.isEmpty ? [p.thumbnail] : p.images)
                .map((u) => Image.network(u))
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        Text(p.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text('\$${p.price.toStringAsFixed(2)}  (diskon ${p.discountPercentage}%)',
            style: const TextStyle(fontSize: 18, color: Colors.indigo)),
        const SizedBox(height: 8),
        Text(p.description),
        const Divider(height: 24),
        _row('Kategori', p.category),
        _row('Brand', p.brand ?? '-'),
        _row('Rating', '${p.rating}'),
        _row('Stok', '${p.stock} (${p.availabilityStatus})'),
        _row('Garansi', p.warrantyInformation),
        _row('Pengiriman', p.shippingInformation),
        _row('Retur', p.returnPolicy),
        const Divider(height: 24),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          IconButton.outlined(
            icon: const Icon(Icons.remove),
            onPressed: _qty > 1 ? () => setState(() => _qty--) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('$_qty', style: const TextStyle(fontSize: 20)),
          ),
          IconButton.outlined(
            icon: const Icon(Icons.add),
            onPressed: _qty < p.stock ? () => setState(() => _qty++) : null,
          ),
        ]),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _addToCart,
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Add to Cart'),
        ),
      ]),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(width: 100, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(v)),
        ]),
      );
}
