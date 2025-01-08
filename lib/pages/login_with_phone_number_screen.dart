import 'package:catalog/pages/verify_code.dart';
import 'package:catalog/utils/util.dart';
import 'package:catalog/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;

  final _formkey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formkey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: phoneController,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Phone Number",
                        hintText: "ex: +91 922 564 454",
                        prefixIcon: Icon(Icons.phone),
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5))),
                    validator: (value) {
                      if (value == null) {
                        return 'Phone number cannot be empty';
                      } else if (value.length < 10) {
                        return 'Password must be at least 4 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  ButtonWidget(
                      title: "Login",
                      loading: loading,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          loading = true;
                        });
                        try {
                          _auth.verifyPhoneNumber(
                              phoneNumber:
                                  '+91${phoneController.text.toString()}',
                              verificationCompleted: (_) {
                                setState(() {
                                  loading = false;
                                });
                              },
                              verificationFailed: (e) {
                                Util().toastMessage(e.toString());
                                setState(() {
                                  loading = false;
                                });
                              },
                              codeSent: (String verificationId, int? token) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VerifyCodeScreen(
                                            verificationId: verificationId)));
                                setState(() {
                                  loading = false;
                                });
                              },
                              codeAutoRetrievalTimeout: (e) {
                                Util().toastMessage(e.toString());
                                setState(() {
                                  loading = false;
                                });
                              });
                        } catch (e) {
                          Util().toastMessage(e.toString());
                        }
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
