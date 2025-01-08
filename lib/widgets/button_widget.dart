import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const ButtonWidget(
      {super.key,
      required this.title,
      required this.onTap,
      this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 300,
      child: ElevatedButton(
        onPressed: onTap,
        child: loading
            ? CircularProgressIndicator(
                strokeWidth: 3,
                color: const Color.fromARGB(255, 230, 219, 219),
              )
            : Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          // overlayColor: Materi,
          minimumSize: const Size(300, 48),
          // maximumSize: Size(300, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
          // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        ),
      ),
    );
  }
}
