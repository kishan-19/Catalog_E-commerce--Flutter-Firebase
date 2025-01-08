import 'package:catalog/provider/cardItemCountProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  MyAppBar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight);
  var itemCount = 2;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: const Center(
        child: Text(
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
                  color: Color.fromARGB(121, 209, 209, 219),
                ),
              ]),
        ),
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
                      child: Consumer<CountItemOfCardProvider>(
                          builder: (ctx, Provider, __) {
                        return Text(
                          '${Provider.getCartItemCount()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        );
                      })))
          ],
        )
      ],
    );
  }
}
