import 'package:catalog/provider/cardItemCountController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Carditemacountcontroller cardItemController =
      Get.put(Carditemacountcontroller());
  @override
  final Size preferredSize;
  MyAppBar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight);
  var itemCount = 2;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 226, 223, 223),
      title: const Text(
        "Catalog",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
            shadows: [
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 2.0,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 0.0,
                color: Color.fromARGB(121, 245, 211, 229),
              ),
            ]),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
      ),
      actions: [
        Stack(
          children: [
            IconButton(
                // onPressed: onMenuPressed,
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(Icons.shopping_cart_checkout_outlined)),
            if (itemCount > 0)
              Positioned(
                  top: 0,
                  right: 9,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    // child: Consumer<CountItemOfCardProvider>(
                    //     builder: (ctx, Provider, __) {
                    //   return Text(
                    //     '${Provider.getCartItemCount()}',
                    //     style: const TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 13,
                    //     ),
                    //   );
                    // }
                    // )
                    child: Obx(() => Text(
                          "${cardItemController.CardItemCount}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        )),
                  ))
          ],
        )
      ],
    );
  }
}
