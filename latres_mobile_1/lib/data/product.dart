class Product {
  final int id;
  final String title, description, category, thumbnail;
  final String? brand;
  final double price, discountPercentage, rating;
  final int stock;
  final List<String> images;
  final String availabilityStatus, warrantyInformation, shippingInformation, returnPolicy;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.thumbnail,
    required this.brand,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.images,
    required this.availabilityStatus,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.returnPolicy,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'],
        title: j['title'],
        description: j['description'],
        category: j['category'],
        thumbnail: j['thumbnail'],
        brand: j['brand'],
        price: (j['price'] as num).toDouble(),
        discountPercentage: (j['discountPercentage'] as num).toDouble(),
        rating: (j['rating'] as num).toDouble(),
        stock: j['stock'],
        images: List<String>.from(j['images'] ?? []),
        availabilityStatus: j['availabilityStatus'] ?? '-',
        warrantyInformation: j['warrantyInformation'] ?? '-',
        shippingInformation: j['shippingInformation'] ?? '-',
        returnPolicy: j['returnPolicy'] ?? '-',
      );
}
