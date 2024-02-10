import 'package:cloud_firestore/cloud_firestore.dart';

class Tractor {
  //id
  final String? id;
  final String dateAdded;
  final String productName;
  final String productDetails;
  final String productPrice;
  final List<String>? productImages; // Adding the selected offences list
  final String? productCategory;
  final bool hired;
  final String topSpeed;
  final String fuelType;
  final String engineCapacity;
  final String fuelConsumption;
  final String power;

  Tractor(
      {this.id,
      required this.dateAdded,
      required this.productName,
      required this.productCategory,
      required this.productDetails,
      required this.productImages,
      required this.productPrice,
      required this.hired,
      required this.topSpeed,
      required this.fuelType,
      required this.engineCapacity,
      required this.fuelConsumption,
      required this.power});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'dateAdded': dateAdded,
        'productName': productName,
        'productCategory': productCategory,
        'productDetails': productDetails,
        'productImages': productImages,
        'productPrice': productPrice,
        'hired': hired,
        'topSpeed': topSpeed,
        'fuelType': fuelType,
        'engineCapacity': engineCapacity,
        'fuelConsumption': fuelConsumption,
        'power': power
      };

  //from json
  factory Tractor.fromJson(Map<String, dynamic> json) => Tractor(
      id: json['id'],
      dateAdded: json["dateAdded"],
      productName: json["productName"],
      productCategory: json['productCategory'],
      productDetails: json["productDetails"],
      productImages: json["productImages"],
      productPrice: json["productPrice"],
      hired: json["hired"],
      topSpeed: json["topSpeed"],
      fuelType: json["fuelType"],
      engineCapacity: json["engineCapacity"],
      fuelConsumption: json["fuelConsumption"],
      power: json["power"]);

  factory Tractor.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Tractor(
        id: document.id,
        productName: data['productName'],
        productCategory: data['productCategory'],
        productDetails: data['productDetails'],
        productImages: data['productImages'],
        productPrice: data['productPrice'],
        dateAdded: data['dateAdded'],
        hired: data['hired'],
        topSpeed: data['topSpeed'],
        fuelType: data['fuelType'],
        engineCapacity: data['engineCapacity'],
        fuelConsumption: data['fuelConsumption'],
        power: data['power']);
  }
}

class Cart {
  //id
  final String? id;
  final String dateAdded;
  final String productName;
  final String productDetails;
  final String productPrice;
  final List<String>? productImages; // Adding the selected offences list
  final String? productCategory;
  final int quantity;

  Cart(
      {this.id,
      required this.dateAdded,
      required this.productName,
      required this.productCategory,
      required this.productDetails,
      required this.productImages,
      required this.quantity,
      required this.productPrice});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'dateAdded': dateAdded,
        'productName': productName,
        'productCategory': productCategory,
        'productDetails': productDetails,
        'productImages': productImages,
        'quantity': quantity,
        'productPrice': productPrice
      };

  //from json
  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
      id: json['id'],
      dateAdded: json["dateAdded"],
      productName: json["productName"],
      productCategory: json['productCategory'],
      productDetails: json["productDetails"],
      quantity: json["quantity"],
      productImages: json["productImages"],
      productPrice: json["productPrice"]);

  factory Cart.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Cart(
      id: document.id,
      productName: data['productName'],
      productCategory: data['productCategory'],
      productDetails: data['productDetails'],
      productImages: data['productImages'],
      quantity: data['quantity'],
      productPrice: data['productPrice'],
      dateAdded: data['dateAdded'],
    );
  }
}

class MyOrder {
  //id
  final String? id;
  final String dateAdded, orderID, totalAmount;
  late final bool paid;
  final List<String>? productName;
  final List<String>? productDetails;
  final List<String>? productPrice;
  final List<String>? productImages; // Adding the selected offences list
  final List<String>? productCategory;
  final List<String>? quantity;

  MyOrder(
      {this.id,
      required this.orderID,
      required this.totalAmount,
      required this.paid,
      required this.dateAdded,
      required this.productName,
      required this.productCategory,
      required this.productDetails,
      required this.productImages,
      required this.quantity,
      required this.productPrice});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'orderID': orderID,
        'totalAmount': totalAmount,
        'paid': paid,
        'dateAdded': dateAdded,
        'productName': productName,
        'productCategory': productCategory,
        'productDetails': productDetails,
        'productImages': productImages,
        'quantity': quantity,
        'productPrice': productPrice
      };

  //from json
  factory MyOrder.fromJson(Map<String, dynamic> json) => MyOrder(
      id: json['id'],
      orderID: json["orderID"],
      totalAmount: json["totalAmount"],
      paid: json['paid'],
      dateAdded: json["dateAdded"],
      productName: json["productName"],
      productCategory: json['productCategory'],
      productDetails: json["productDetails"],
      quantity: json["quantity"],
      productImages: json["productImages"],
      productPrice: json["productPrice"]);

  factory MyOrder.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return MyOrder(
      id: document.id,
      orderID: document['orderID'],
      totalAmount: data['totalAmount'],
      productCategory: data['productCategory'],
      productName: data['productName'],
      paid: data['paid'],
      productDetails: data['productDetails'],
      productImages: data['productImages'],
      quantity: data['quantity'],
      productPrice: data['productPrice'],
      dateAdded: data['dateAdded'],
    );
  }
}

//create class comment model with the following fields : comment, likes, approved,date

class Comment {
  final String? id;
  final String? comment;
  final int? numberOfLikes;
  final int? numberOfDislikes;

  final String? approved;
  final String? date;
  final String? productID;
  final String? userID;

  Comment(
      {this.id,
      this.comment,
      this.numberOfLikes,
      this.numberOfDislikes,
      this.approved,
      this.date,
      this.productID,
      this.userID});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'comment': comment,
        'numberOfLikes': numberOfLikes,
        'numberOfDislikes': numberOfDislikes,
        'approved': approved,
        'date': date,
        'productID': productID,
        'userID': userID,
      };

  //from json
  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        comment: json['comment'],
        numberOfLikes: json['numberOfLikes'],
        numberOfDislikes: json['numberOfDislikes'],
        approved: json['approved'],
        date: json['date'],
        productID: json['productID'],
        userID: json['userID'],
      );

  factory Comment.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Comment(
      id: document.id,
      comment: data['comment'],
      numberOfLikes: data['numberOfLikes'],
      numberOfDislikes: data['numberOfDislikes'],
      approved: data['approved'],
      date: data['date'],
      productID: data['productID'],
      userID: data['userID'],
    );
  }
}

class LikeAndDislike {
  final String? id;
  final String? productID;
  final String? userID;
  final String? date;

  LikeAndDislike({this.id, this.productID, this.userID, this.date});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'productID': productID,
        'userID': userID,
        'date': date,
      };

  //from json
  factory LikeAndDislike.fromJson(Map<String, dynamic> json) => LikeAndDislike(
        id: json['id'],
        productID: json['productID'],
        userID: json['userID'],
        date: json['date'],
      );

  factory LikeAndDislike.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return LikeAndDislike(
      id: document.id,
      productID: data['productID'],
      userID: data['userID'],
      date: data['date'],
    );
  }
}

class MyHiring {
  //id
  final String? id;
  final String dateAdded;
  final DateTime? endDate;
  final String productName;
  final String? userId;
  final String? firstName, lastName;
  final String productDetails;
  final String productPrice;
  final List<String>? productImages; // Adding the selected offences list
  final String? productCategory;
  final int quantity;
  final String totalAmount;
  final bool hired;
  final String topSpeed;
  final String fuelType;
  final String engineCapacity;
  final String fuelConsumption;
  final String power;

  MyHiring(
      {this.id,
      this.userId,
      this.endDate,
      this.firstName,
      this.lastName,
      required this.dateAdded,
      required this.productName,
      required this.productCategory,
      required this.productDetails,
      required this.productImages,
      required this.quantity,
      required this.totalAmount,
      required this.productPrice,
      required this.hired,
      required this.topSpeed,
      required this.fuelType,
      required this.engineCapacity,
      required this.fuelConsumption,
      required this.power});

  //to json
  Map<String, dynamic> toJson() => {
        'id': id,
        'endDate': endDate,
        'firstName': firstName,
        'lastName': lastName,
        'userId': userId,
        'dateAdded': dateAdded,
        'productName': productName,
        'productCategory': productCategory,
        'productDetails': productDetails,
        'productImages': productImages,
        'quantity': quantity,
        'productPrice': productPrice,
        'hired': hired,
        'topSpeed': topSpeed,
        'fuelType': fuelType,
        'totalAmount': totalAmount,
        'engineCapacity': engineCapacity,
        'fuelConsumption': fuelConsumption,
        'power': power
      };

  //from json
  factory MyHiring.fromJson(Map<String, dynamic> json) => MyHiring(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      endDate: json['endDate'],
      userId: json['userId'],
      dateAdded: json["dateAdded"],
      productName: json["productName"],
      productCategory: json['productCategory'],
      productDetails: json["productDetails"],
      quantity: json["quantity"],
      productImages: json["productImages"],
      productPrice: json["productPrice"],
      hired: json["hired"],
      topSpeed: json["topSpeed"],
      fuelType: json["fuelType"],
      totalAmount: json["totalAmount"],
      engineCapacity: json["engineCapacity"],
      fuelConsumption: json["fuelConsumption"],
      power: json["power"]);

  factory MyHiring.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return MyHiring(
        id: document.id,
        firstName: data['firstName'],
        lastName: data['lastName'],
        endDate: data['endDate'],
        userId: data['userId'],
        productName: data['productName'],
        productCategory: data['productCategory'],
        productDetails: data['productDetails'],
        productImages: data['productImages'],
        quantity: data['quantity'],
        productPrice: data['productPrice'],
        dateAdded: data['dateAdded'],
        hired: data['hired'],
        totalAmount: data['totalAmount'],
        topSpeed: data['topSpeed'],
        fuelType: data['fuelType'],
        engineCapacity: data['engineCapacity'],
        fuelConsumption: data['fuelConsumption'],
        power: data['power']);
  }
}
