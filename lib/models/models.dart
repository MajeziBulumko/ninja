class Product {
  final int? id;
  final int catid;
  final int stid;
  final String name;
  final double units;
  final String uom;
  final double price;
  final double ppu;

  const Product(
      {required this.name,
      required this.catid,
      required this.stid,
      required this.units,
      required this.uom,
      required this.price,
      required this.ppu,
      this.id});

  // ignore: empty_constructor_bodies
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        units: json['units'],
        uom: json['uom'],
        price: json['price'],
        ppu: json['ppu'],
        catid: json['catid'],
        stid: json['stid'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'units': units,
        'uom': uom,
        'price': price,
        'ppu': ppu,
        'catid': catid,
        'stid': stid,
      };
}

class Category {
  final int? catid;
  final String category;

  const Category({required this.category, this.catid});

  // ignore: empty_constructor_bodies
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        catid: json['catid'],
        category: json['category'],
      );

  Map<String, dynamic> toJson() => {
        'catid': catid,
        'category': category,
      };
}

class Store {
  final int? stid;
  final String storeName;

  const Store({required this.stid, required this.storeName});

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        stid: json['stid'],
        storeName: json['store'],
      );

  Map<String, dynamic> toJson() => {
        'stid': stid,
        'storeName': storeName,
      };
}
