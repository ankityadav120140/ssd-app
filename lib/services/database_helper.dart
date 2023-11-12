// ignore_for_file: depend_on_referenced_packages, avoid_print, unrelated_type_equality_checks
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ssd_app/contollers/product_controller.dart';
import 'package:ssd_app/models/user.dart';
import 'package:ssd_app/models/cart_product.dart';

import '../models/category.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return instance;
  }

  DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initDatabase();
      return _database!;
    }
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'ssd.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE IF NOT EXISTS user (
          id TEXT PRIMARY KEY,
          name TEXT,
          mobile TEXT,
          api_token TEXT
        )
      ''');
// 0 : nothig, 1 : update, 2 : insert, 3 : delete, 4 : insert and update , 5 : insert and delete
        await db.execute('''
        CREATE TABLE IF NOT EXISTS cartProducts (
          id INTEGER PRIMARY KEY,
          slabId INTEGER,
          inventoryId INTEGER,
          productId INTEGER,
          name TEXT,
          price REAL,
          mrp REAL,
          quantity INTEGER,
          status INTEGER
        )
      ''');

        await db.execute('''
        CREATE TABLE IF NOT EXISTS categories (
          id INTEGER PRIMARY KEY,
          name TEXT
        )
      ''');

        await db.execute('''
          CREATE TABLE IF NOT EXISTS featuredProducts (
            id INTEGER PRIMARY KEY,
            product_name TEXT,
            product_detail TEXT,
            category INTEGER,
            selling_price REAL,
            mrp REAL,
            inventory_id INTEGER
          )
        ''');
      },
    );
  }

//method for user

  Future<int> insertUser(User user) async {
    final db = await database;
    try {
      return await db.insert('user', user.toJson());
    } catch (e) {
      print("Exception In Insert User: $e");
      return -1;
    }
  }

  Future<int> deleteUser(String id) async {
    final db = await database;
    return await db.delete(
      'user',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<User?> getUser() async {
    final db = await database;
    const String query = "SELECT * FROM user";
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }

  // Methods for CartProducts Table

  Future<void> clearCartItems() async {
    final Database db = await database;
    await db.delete('cartProducts');
  }

  Future<int> insertCartItems(List<CartProduct> cartProducts) async {
    print("STATUS CODE : 0");
    try {
      final Database db = await database;
      final Batch batch = db.batch();

      for (final cartProduct in cartProducts) {
        batch.insert(
          'cartProducts',
          {
            'id': cartProduct.id,
            'slabId': cartProduct.slabId,
            'inventoryId': cartProduct.inventoryId,
            'productId': cartProduct.productId,
            'name': cartProduct.name,
            'price': cartProduct.price,
            'quantity': cartProduct.quantity,
            'mrp': cartProduct.mrp,
            'status': 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
      return 1;
    } catch (e) {
      print("Error in inserting items in db : $e");
      return -1;
    }
  }

  Future<int> insertCartProduct(Product product) async {
    print("STATUS CODE : 2");
    ProductController productController = Get.find();
    final db = await database;
    try {
      final values = <String, dynamic>{
        'id': product.id,
        'slabId':
            int.tryParse(productController.calculateSlabId(1, product)) ?? 0,
        'inventoryId': product.inventoryId,
        'productId': product.id,
        'name': product.name,
        'price': product.sellingPrice,
        'quantity': 1,
        'mrp': product.mrp,
        'status': 2
      };
      return await db.insert('cartProducts', values);
    } catch (e) {
      print("Exception In Insert CartProduct: $e");
      return -1;
    }
  }

  Future<int> addCartProduct(CartProduct cartProduct) async {
    print("STATUS CODE : ${cartProduct.status == 2 ? 4 : 1}");
    print("ADDING EXISTING");
    ProductController productController = Get.find();
    Product? product =
        await productController.findProduct(cartProduct.productId);
    String slabId =
        productController.calculateSlabId(cartProduct.quantity + 1, product!);
    ProductSlab? selectedSlab = product.productSlabs.firstWhere(
      (slab) => slab.id == slabId,
      orElse: () => ProductSlab(
          id: 0,
          slabMinValue: 0,
          slabMaxValue: 0,
          sellingPrice: cartProduct.price),
    );
    final db = await database;
    final values = <String, dynamic>{
      'slabId': cartProduct.slabId,
      'inventoryId': cartProduct.inventoryId,
      'productId': cartProduct.productId,
      'name': cartProduct.name,
      'price': selectedSlab.sellingPrice,
      'quantity': cartProduct.quantity + 1,
      'mrp': cartProduct.mrp,
      'status': cartProduct.status == 2 ? 4 : 1,
    };
    return await db.update(
      'cartProducts',
      values,
      where: 'id = ?',
      whereArgs: [cartProduct.id],
    );
  }

  Future<int> removeCartProduct(CartProduct cartProduct) async {
    print("STATUS CODE : ${cartProduct.status == 2 ? 4 : 1}");
    final db = await database;
    final values = <String, dynamic>{
      'slabId': cartProduct.slabId,
      'inventoryId': cartProduct.inventoryId,
      'productId': cartProduct.productId,
      'name': cartProduct.name,
      'price': cartProduct.price,
      'quantity': cartProduct.quantity - 1,
      'mrp': cartProduct.mrp,
      'status': cartProduct.status == 2 ? 4 : 1,
    };
    return await db.update(
      'cartProducts',
      values,
      where: 'id = ?',
      whereArgs: [cartProduct.id],
    );
  }

  Future<int> deleteCartProduct(CartProduct cartProduct) async {
    print("STATUS CODE : ${cartProduct.status == 2 ? 5 : 3}");
    final db = await database;
    if (cartProduct.status == 2) {
      await db.delete(
        'cartProducts',
        where: 'id = ?',
        whereArgs: [cartProduct.id],
      );
      return 5;
    }
    final values = <String, dynamic>{
      'slabId': cartProduct.slabId,
      'inventoryId': cartProduct.inventoryId,
      'productId': cartProduct.productId,
      'name': cartProduct.name,
      'price': cartProduct.price,
      'quantity': 0,
      'mrp': cartProduct.mrp,
      'status': 3,
    };

    final result = await db.update(
      'cartProducts',
      values,
      where: 'id = ?',
      whereArgs: [cartProduct.id],
    );
    return result;
  }

  Future<List<CartProduct>> getAllCartProducts() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query("cartProducts");
      final List<CartProduct> cartProducts = List.generate(maps.length, (i) {
        return CartProduct.fromJsonLocal(maps[i]);
      });
      // Filter cart products by status codes (0, 1, 2, 4)
      final filteredCartProducts = cartProducts
          .where((cartProduct) => [0, 1, 2, 3, 4].contains(cartProduct.status))
          .toList();

      return filteredCartProducts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<CartProduct>> getNewlyAddedCartProducts() async {
    final dbHelper = DatabaseHelper();
    List<CartProduct> allCartProducts = await dbHelper.getProducts();
    return allCartProducts
        .where((cartProduct) => cartProduct.status == 2)
        .toList();
  }

  Future<List<CartProduct>> getUpdatedCartProducts() async {
    final dbHelper = DatabaseHelper();
    List<CartProduct> allCartProducts = await dbHelper.getProducts();
    return allCartProducts
        .where((cartProduct) => cartProduct.status == 1)
        .toList();
  }

  Future<List<CartProduct>> getAddedAndUpdatedCartProducts() async {
    final dbHelper = DatabaseHelper();
    List<CartProduct> allCartProducts = await dbHelper.getProducts();
    return allCartProducts
        .where((cartProduct) => cartProduct.status == 4)
        .toList();
  }

  Future<List<CartProduct>> getDeletedCartProducts() async {
    final dbHelper = DatabaseHelper();
    List<CartProduct> allCartProducts = await dbHelper.getProducts();
    return allCartProducts
        .where((cartProduct) => cartProduct.status == 3)
        .toList();
  }

  Future<List<CartProduct>> getProducts() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query("cartProducts");
      final List<CartProduct> cartProducts = List.generate(maps.length, (i) {
        return CartProduct.fromJsonLocal(maps[i]);
      });
      return cartProducts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //method for categories
  Future<int> insertCategories(List<Category> categories) async {
    try {
      final Database db = await database;
      final Batch batch = db.batch();
      for (final category in categories) {
        batch.insert('categories', category.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
      return 1;
    } catch (e) {
      print("Error in inserting categories in db : $e");
      return -1;
    }
  }

  Future<void> clearCategories() async {
    final Database db = await database;
    await db.delete('categories');
  }

  Future<List<Category>> getAllCategories() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query('categories');
      return List.generate(maps.length, (i) {
        return Category.fromJson(maps[i]);
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  //method for featuredProducts

  Future<int> insertFeaturedProducts(List<Product> featuredProducts) async {
    try {
      final Database db = await database;
      final Batch batch = db.batch();
      for (final product in featuredProducts) {
        batch.insert('featuredProducts', product.toJsonLocal(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
      return 1;
    } catch (e) {
      print("Error in inserting featured products in db : $e");
      return -1;
    }
  }

  Future<void> clearFeaturedProducts() async {
    final Database db = await database;
    await db.delete('featuredProducts');
  }

  Future<List<Product>> getAllFeaturedProducts() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps =
          await db.query('featuredProducts');
      return List.generate(maps.length, (i) {
        return Product.fromJsonLocal(maps[i]);
      });
    } catch (e) {
      print(e);
      return [];
    }
  }
}
