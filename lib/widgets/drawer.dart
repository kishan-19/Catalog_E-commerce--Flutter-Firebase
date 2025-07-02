import 'package:catalog/admin_pages/add_product_screen.dart';
import 'package:catalog/pages/categories_screen.dart';
import 'package:catalog/pages/login.dart';
import 'package:catalog/utils/util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  String? userName;
  ProfileDrawer({super.key,this.userName});

  // String Name = userName?.split('@')
  //     .first
  //     .replaceAll(RegExp(r'[^a-zA-Z]'), '') ?? '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.deepPurple,
        child: ListView(
          children: [
             DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                accountName: Text("hii, ${userName?.split('@')
                    .first
                    .replaceAll(RegExp(r'[^a-zA-Z]'), '') ?? 'Not Found'}"),
                accountEmail: Text(userName.toString()),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage("assets/images/about.jpg"),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Categoris()));
              },
              child: const ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                leading: Icon(CupertinoIcons.home),
                title: Text(
                  "Home",
                  textScaler: TextScaler.linear(1.2),
                ),
              ),
            ),
            const ListTile(
              iconColor: Colors.white,
              textColor: Colors.white,
              leading: Icon(CupertinoIcons.profile_circled),
              title: Text(
                "Profile",
                textScaler: TextScaler.linear(1.2),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddProduct()));
              },
              child: const ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                leading: Icon(CupertinoIcons.add_circled),
                title: Text(
                  "Add Product",
                  textScaler: TextScaler.linear(1.2),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _auth.signOut().then((value) {
                  Util().toastMessage("Logout Successfully");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, StackTrace) {
                  Util().toastMessage(error.toString());
                });
              },
              child: const ListTile(
                iconColor: Colors.white,
                textColor: Colors.white,
                leading: Icon(Icons.logout_outlined),
                title: Text(
                  "Logout",
                  textScaler: TextScaler.linear(1.2),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
