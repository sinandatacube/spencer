import 'dart:developer';

import 'package:flutter/material.dart';

class BulkProvider extends ChangeNotifier {
  List searchedd = [];
  List prodIdsss = [];
  List productDetailss = [];
  String keyword = "";

  clearQuantity() {
    prodIdsss.clear();
    notifyListeners();
  }

  clearAllData() {
    searchedd.clear();
    prodIdsss.clear();
    productDetailss.clear();
    keyword = "";
  }

  clearQuery() {
    keyword = "";
    notifyListeners();
  }

  addQuantity(List temp) {
    prodIdsss.clear();
    prodIdsss.addAll(temp);
    notifyListeners();
  }

  addDetails(List details) {
    productDetailss.clear();
    productDetailss.addAll(details);
    log("asd");
    notifyListeners();
  }

  getSearchedData(String query) {
    keyword = query;
    searchedd = productDetailss
        .where((element) =>
            element["product_name"].toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  removeItemFromCart(String productId) {
    prodIdsss.removeWhere(
      (element) => element["product_id"] == productId,
    );
    notifyListeners();
  }

  addItemToCart(String productId, int quantity) {
    prodIdsss.add({"product_id": productId, "qantity": quantity});
    notifyListeners();
  }
}
