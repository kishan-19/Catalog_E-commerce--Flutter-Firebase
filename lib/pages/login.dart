import 'package:catalog/pages/categories_screen.dart';
import 'package:catalog/pages/login_with_phone_number_screen.dart';
import 'package:catalog/pages/signup.dart';
import 'package:catalog/utils/util.dart';
import 'package:catalog/widgets/button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      _auth
          .signInWithEmailAndPassword(
              email: emailController.text.toString(),
              password: passwordController.text.toString())
          .then((value) {
        Util().toastMessage(value.user!.email.toString());
        setState(() {
          loading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Categoris(userName:emailController.text)));
      }).onError((error, StackTrace) {
        Util().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          // child: Container(
          // width: 300,
          // height: 360,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text(
                    "Welcome back",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w700,
                      // decoration: TextDecoration.underline,
                    ),
                    textScaler: TextScaler.linear(1.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                          labelText: "Email",
                          hintText: "Enter Your Email address",
                          labelStyle: TextStyle(color: Colors.black),
                          border: OutlineInputBorder(),
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5))),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Email address cannot be empty.";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 22,
                  ),
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
                    height: 20,
                  ),
                  ButtonWidget(
                      title: "Login",
                      loading: loading,
                      onTap: () {
                        login();
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignupScreen()));
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                                color: Color.fromARGB(255, 10, 2, 238),
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginWithPhoneNumber())),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border:
                              Border.all(color: Colors.deepPurple.shade300)),
                      child: const Center(
                        child: Text(
                          "Login with phone number",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  )
                  // ButtonWidget(
                  //     title: "Login with phone",
                  //     onTap: () => Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) =>
                  //                 const LoginWithPhoneNumber())))
                ],
              ),
            ),
          ),
          // ),
        ),
      ),
    );
  }
}
