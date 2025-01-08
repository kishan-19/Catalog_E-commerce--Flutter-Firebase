import 'package:flutter/material.dart';

class CountItemOfCardProvider extends ChangeNotifier {
  int _CardItemCount = 0;

  int getCartItemCount() => _CardItemCount;

  void setCardItemCount() {
    // _CardItemCount = ItemCountValu;
    _CardItemCount++;
    notifyListeners();
  }

  void removeCardItemCount() {
    if (_CardItemCount > 0) {
      _CardItemCount--;
      notifyListeners();
    }
  }
}
