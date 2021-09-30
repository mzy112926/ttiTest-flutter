
class ProductItem {
  int id;
  String sku;
  String name;
  int price;
  String createdat;
  String updatedat;

  ProductItem(
      {required this.id, required this.sku, required this.name, required this.price, required this.createdat, required this.updatedat});

  factory ProductItem.fromJson(Map<String, dynamic> json) {
    return ProductItem(
        id: json['id'] ?? 0,
        sku: json['sku'] ?? '',
        name: json['name'] ?? '',
        price: json['price'] ?? 0,
        createdat: json['created_at'] ?? '',
        updatedat: json['updated_at'] ?? '');
  }
}