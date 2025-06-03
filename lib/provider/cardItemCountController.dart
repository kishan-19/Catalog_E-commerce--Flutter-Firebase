import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Carditemacountcontroller extends GetxController {
  RxInt CardItemCount = 0.obs;

  static const CARDKEYY = 'CardCount';

  // RxInt getCartItemCount() => CardItemCount;
  void getCardCountIntoSP() async {
    final pref = await SharedPreferences.getInstance();
    CardItemCount.value = pref.getInt(CARDKEYY) ?? 0;

    // if (sharedPreferencesCardCount != Null) {
    //   CardItemCount = sharedPreferencesCardCount as RxInt;
    // }
  }

  void setCardItema(int qlt) async {
    CardItemCount += qlt;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(CARDKEYY, CardItemCount.value);
  }

  void removeCardItema(int qlt) async {
    CardItemCount -= qlt;
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(CARDKEYY, CardItemCount.value);
  }
}
