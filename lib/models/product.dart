// TODO Implement this library.import 'dart:convert';

import 'dart:convert';

class Product {
  bool available;
  String? picture;
  double price;
  String name;
  String? id;

  Product(
      {required this.available,
      this.picture,
      required this.price,
      required this.name,
      this.id});

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        available: json["available"],
        picture: json["picture"],
        price: json["price"]?.toDouble(),
        name: json["name"],
      );

  Map<String, dynamic> toMap() => {
        "available": available,
        "picture": picture,
        "price": price,
        "name": name,
      };

  Product copy() => Product(
      available: available, picture: picture, price: price, name: name, id: id);
}
