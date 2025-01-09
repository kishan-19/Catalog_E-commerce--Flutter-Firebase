import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountItemOfCardProvider extends ChangeNotifier {
  int _CardItemCount = 0;

  static const CARDKEY = 'cardCount';

  int getCartItemCount() => _CardItemCount;
  void getCardCountIntoSP() async {
    var pref = await SharedPreferences.getInstance();
    _CardItemCount = pref.getInt(CARDKEY)!;
    notifyListeners();
  }

  void setCardItemCount(int qlty) async {
    _CardItemCount += qlty;
    var pref = await SharedPreferences.getInstance();
    pref.setInt(CARDKEY, _CardItemCount);
    notifyListeners();
  }

  void removeCardItemCount(int qlty) async {
    _CardItemCount -= qlty;
    var pref = await SharedPreferences.getInstance();
    pref.setInt(CARDKEY, _CardItemCount);
    notifyListeners();
  }
}
