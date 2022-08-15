import 'dart:convert';

import 'package:delivery_flutter/src/models/product.dart';
import 'package:delivery_flutter/src/models/user.dart';

import 'address.dart';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  String? id;
  String? idClient;
  String? idDelivery;
  String? idAddress;
  String? status;
  double? lat;
  double? lng;
  int? timestamp;
  List<Product>? products = [];
  User? client;
  User? delivery;
  Address? address;

  Order({
    this.id,
    this.idClient,
    this.idDelivery,
    this.idAddress,
    this.status,
    this.lat,
    this.lng,
    this.timestamp,
    this.products,
    this.address,
    this.client,
    this.delivery
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    idClient: json["id_client"],
    idDelivery: json["id_delivery"],
    idAddress: json["id_address"],
    status: json["status"],
    products: json["products"] != null ? List<Product>.from(json["products"].map((model) => model is Product ? model : Product.fromJson(model))) : [],
    lat: json["lat"],
    lng: json["lng"],
    timestamp: json["timestamp"],
    client: json['client'] is String ? userFromJson(json['client']): json['client'] is User ? json['client'] : User.fromJson(json['client'] ?? {}),
    delivery: json['delivery'] is String ? userFromJson(json['delivery']): json['delivery'] is User ? json['delivery'] : User.fromJson(json['delivery'] ?? {}),
    address: json['address'] is String ? addressFromJson(json['address']): json['address'] is Address ? json['address'] : Address.fromJson(json['address'] ?? {}),
  );

  static List<Order> fromJsonList(List<dynamic> jsonList) {
    List<Order> toList = [];

    jsonList.forEach((item) {
      Order order = Order.fromJson(item);
      toList.add(order);
    });

    return toList;
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_client": idClient,
    "id_delivery": idDelivery,
    "id_address": idAddress,
    "status": status,
    "lat": lat,
    "lng": lng,
    "timestamp": timestamp,
    "products": products,
    "client": client,
    "delivery": delivery,
    "address": address,
  };
}
