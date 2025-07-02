import 'package:catalog/main.dart';
import 'package:catalog/pages/home.dart';
import 'package:catalog/provider/cardItemCountController.dart';
import 'package:catalog/widgets/appbar.dart';
import 'package:catalog/widgets/card_drawer.dart';
import 'package:catalog/widgets/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Categoris extends StatefulWidget {
  String? userName;
   Categoris({super.key, this.userName});

  @override
  State<Categoris> createState() => _CategorisState();
}

class _CategorisState extends State<Categoris> {
  final fireStore =
      FirebaseFirestore.instance.collection("categories").snapshots();
  final Carditemacountcontroller cardItemController =
      Get.put(Carditemacountcontroller());
  @override
  void initState() {
    super.initState();
    // context.read<CountItemOfCardProvider>().getCardCountIntoSP();
    cardItemController.getCardCountIntoSP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Container(
        color: const Color.fromARGB(179, 235, 226, 226),
        child: StreamBuilder<QuerySnapshot>(
          stream: fireStore,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                // heroId = "2";
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                categoryId: snapshot.data!.docs[index]['id'])));
                  },
                  // child: Hero(
                  //   tag: snapshot.data!.docs[index].toString(),
                  child: Padding(
                    padding: const EdgeInsets.all(4.5),
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              snapshot.data!.docs[index]['imageURL'].toString(),
                              height: 125,
                              width: 125,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              snapshot.data!.docs[index]['name'],
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // ),
                );
              },
            );
          },
        ),
      ),
      endDrawer: CardDrawer(),
      drawer: ProfileDrawer(userName: widget.userName),
    );
  }
}
