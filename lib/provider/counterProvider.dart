import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _productCount = 1;

  int getProductCount() => _productCount;

  void incrementProductCount() {
    _productCount++;
    notifyListeners();
  }

  void decrementProductCount() {
    if (_productCount > 1) {
      _productCount--;
      notifyListeners();
    }
  }
}
