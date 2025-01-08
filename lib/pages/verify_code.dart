import 'package:catalog/pages/categories_screen.dart';
import 'package:catalog/utils/util.dart';
import 'package:catalog/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

bool loading = false;
final _auth = FirebaseAuth.instance;

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  String _OTP = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                6,
                (index) => SizedBox(
                  width: 50,
                  height: 65,
                  child: TextField(
                    controller: _controllers[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      if (value.length == 1) {
                        if (index < 5) {
                          FocusScope.of(context).nextFocus();
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            ButtonWidget(
                title: "Verify OTP",
                loading: loading,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  setState(() {
                    loading = true;
                  });
                  _OTP = _controllers.map((e) => e.text).join('');

                  try {
                    final creadital = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId, smsCode: _OTP);

                    await _auth.signInWithCredential(creadital);
                    setState(() {
                      loading = false;
                    });
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Categoris()));
                  } catch (e) {
                    setState(() {
                      loading = true;
                    });
                    Util().toastMessage(e.toString());
                  }
                })
          ],
        ),
      ),
    );
  }
}
