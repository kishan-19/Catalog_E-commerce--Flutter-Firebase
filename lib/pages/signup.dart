import 'package:catalog/pages/categories_screen.dart';
import 'package:catalog/pages/login.dart';
import 'package:catalog/utils/util.dart';
import 'package:catalog/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void signUp() {
    setState(() {
      loading = true;
    });
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Categoris()));
    }).onError((error, StackTrace) {
      Util().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsetsDirectional.only(top: 20),
            width: 300,
            height: 554,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "sign up".toUpperCase(),
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      // decoration: TextDecoration.underline,
                    ),
                    textScaler: const TextScaler.linear(1.0),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  // TextFormField(
                  //     keyboardType: TextInputType.text,
                  //     cursorColor: Colors.black,
                  //     decoration: InputDecoration(
                  //         labelText: "Username",
                  //         hintText: "Enter Your Username",
                  //         labelStyle: TextStyle(color: Colors.black),
                  //         border: OutlineInputBorder(),
                  //         fillColor: Colors.black,
                  //         focusColor: Colors.black,
                  //         focusedBorder: OutlineInputBorder(
                  //             borderSide:
                  //                 BorderSide(color: Colors.black, width: 1.5))),
                  //     validator: (value) {
                  //       if (value.toString().isEmpty) {
                  //         return "Username cannot be empty.";
                  //       }
                  //       return null;
                  //     }),
                  // SizedBox(
                  //   height: 17,
                  // ),
                  TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Enter Your Email",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5))),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Email cannot be empty.";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 17,
                  ),
                  // TextFormField(
                  //     keyboardType: TextInputType.text,
                  //     cursorColor: Colors.black,
                  //     decoration: InputDecoration(
                  //         labelText: "Phone Number",
                  //         hintText: "Enter Your Phone Number",
                  //         labelStyle: TextStyle(color: Colors.black),
                  //         border: OutlineInputBorder(),
                  //         fillColor: Colors.black,
                  //         focusColor: Colors.black,
                  //         focusedBorder: OutlineInputBorder(
                  //             borderSide:
                  //                 BorderSide(color: Colors.black, width: 1.5))),
                  //     validator: (value) {
                  //       if (value == null) {
                  //         return "Phone Number cannot be empty.";
                  //       } else if (value.length < 10) {
                  //         return "Phone Number must be at least 10 characters";
                  //       } else if (value == num) {
                  //         return null;
                  //       }
                  //     }),
                  // SizedBox(
                  //   height: 17,
                  // ),
                  TextFormField(
                    controller: passwordController,
                    cursorColor: Colors.black,
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: "password",
                        hintText: "Enter Your Password",
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        fillColor: Colors.black,
                        focusColor: Colors.black,
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.5))),
                    validator: (value) {
                      if (value == null) {
                        return 'Username cannot be empty';
                      } else if (value.length < 4) {
                        return 'Password must be at least 4 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Container(
                  //   // width: 300,
                  //   child: ElevatedButton(
                  //     onPressed: () => moveToHomePage(context),
                  //     child: Text(
                  //       "Sign up",
                  //       style: TextStyle(color: Colors.white, fontSize: 20),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.black,
                  //       // overlayColor: Materi,
                  //       minimumSize: Size(300, 48),
                  //       // maximumSize: Size(300, 50),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(0.0)),
                  //       // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  //     ),
                  //   ),
                  // ),
                  ButtonWidget(
                      title: "sign up",
                      loading: loading,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (_formKey.currentState!.validate()) {
                          signUp();
                        }
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a Member ?"),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                                color: Color.fromARGB(255, 10, 2, 238),
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
