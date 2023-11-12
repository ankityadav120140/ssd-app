class CartProduct {
  int id;
  int slabId;
  int inventoryId;
  int productId;
  String name;
  double price;
  double mrp;
  int quantity;
  int? status;

  CartProduct({
    required this.id,
    required this.slabId,
    required this.inventoryId,
    required this.productId,
    required this.name,
    required this.price,
    required this.mrp,
    required this.quantity,
    this.status,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    return CartProduct(
      id: int.tryParse(json['id'].toString()) ?? 0,
      slabId: int.tryParse(json['slab_id'].toString()) ?? 0,
      inventoryId: int.tryParse(json['inventories']['id'].toString()) ?? 0,
      productId: int.tryParse(json['product_id'].toString()) ?? 0,
      name: json['product']['print_name'] ?? 'ITEM',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      mrp: double.tryParse(json['inventories']['transaction']['purchase_data']
                  ['mrp']
              .toString()) ??
          0.0,
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJsonLocal() {
    return {
      'id': id,
      'slabId': slabId,
      'inventoryId': inventoryId,
      'productId': productId,
      'name': name,
      'price': price,
      'mrp': mrp,
      'quantity': quantity,
      'status': 0,
    };
  }

  factory CartProduct.fromJsonLocal(Map<String, dynamic> json) {
    return CartProduct(
      id: json['id'] as int,
      slabId: json['slabId'] as int,
      inventoryId: json['inventoryId'] as int,
      productId: json['productId'] as int,
      name: json['name'] as String,
      price: json['price'] as double,
      mrp: json['mrp'] as double,
      quantity: json['quantity'] as int,
      status: json['status'] as int,
    );
  }
}
