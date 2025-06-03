import 'package:catalog/pages/home.dart';
import 'package:catalog/pages/login.dart';
import 'package:catalog/pages/product_detaile.dart';
import 'package:catalog/pages/splash_screen.dart';
import 'package:catalog/provider/counterProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:catalog/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => CounterProvider()),
    // ChangeNotifierProvider(create: (context) => CountItemOfCardProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: ChangeNotifierProvider(
      //   create: (_) => CounterProvider(),
      //   child: pDetaile("2"),
      // ),
      // title: Text("welcome"),
      // themeMode: ThemeMode.light,
      // initialRoute: "/login",
      routes: {
        "/": (context) => splash_screen(),
        // "/": (context) {
        //   ChangeNotifierProvider(
        //     create: (_) => CounterProvider(),
        //     child: HomeScreen(),
        //   );
        // },
      },
    );
  }
}
