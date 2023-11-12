class Product {
  int id;
  String name;
  String description;
  int category;
  double sellingPrice;
  double mrp;
  int inventoryId;
  List<ProductSlab> productSlabs;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.sellingPrice,
    required this.mrp,
    required this.inventoryId,
    required this.productSlabs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final List<dynamic> slabDataList = json['customer_inventories']
            ['transaction']['purchase_data']['product_slab'] ??
        [];

    final List<ProductSlab> productSlabs = slabDataList.map((slabData) {
      return ProductSlab.fromJson(slabData);
    }).toList();

    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['print_name'] ?? "Item",
      description: json['product_detail'] ?? "",
      category: int.tryParse(json['id'].toString()) ?? 0,
      sellingPrice: double.tryParse(json['customer_inventories']['transaction']
                  ['purchase_data']['default_price']
              .toString()) ??
          0.0,
      mrp: double.tryParse(json['customer_inventories']['transaction']
                  ['purchase_data']['mrp']
              .toString()) ??
          0.0,
      inventoryId:
          int.tryParse(json['customer_inventories']['id'].toString()) ?? 0,
      productSlabs: productSlabs,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': name,
      'product_detail': description,
      'category': category,
      'selling_price': sellingPrice,
      'mrp': mrp,
      'inventory_id': inventoryId,
      'product_slab': productSlabs.map((slab) => slab.toJson()).toList(),
    };
  }

  factory Product.fromJsonLocal(Map<String, dynamic> json) {
    return Product(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['product_name'] ?? "Item",
      description: json['product_detail'] ?? "",
      category: int.tryParse(json['category'].toString()) ?? 0,
      sellingPrice: double.tryParse(json['selling_price'].toString()) ?? 0.0,
      mrp: double.tryParse(json['mrp'].toString()) ?? 0.0,
      inventoryId: int.tryParse(json['inventory_id'].toString()) ?? 0,
      productSlabs: [],
    );
  }

  Map<String, dynamic> toJsonLocal() {
    return {
      'id': id,
      'product_name': name,
      'product_detail': description,
      'category': category,
      'selling_price': sellingPrice,
      'mrp': mrp,
      'inventory_id': inventoryId,
    };
  }
}

class ProductSlab {
  int id;
  int slabMinValue;
  int slabMaxValue;
  double sellingPrice;

  ProductSlab({
    required this.id,
    required this.slabMinValue,
    required this.slabMaxValue,
    required this.sellingPrice,
  });

  factory ProductSlab.fromJson(Map<String, dynamic> json) {
    return ProductSlab(
      id: int.tryParse(json['id'].toString()) ?? 0,
      slabMinValue: int.tryParse(json['slab_min_value'].toString()) ?? 0,
      slabMaxValue: int.tryParse(json['slab_max_value'].toString()) ?? 0,
      sellingPrice: double.tryParse(json['selling_price'].toString()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slab_min_value': slabMinValue,
      'slab_max_value': slabMaxValue,
      'selling_price': sellingPrice,
    };
  }
}
