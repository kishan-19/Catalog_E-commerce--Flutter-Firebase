import 'package:catalog/widgets/appbar.dart';
import 'package:catalog/widgets/card_drawer.dart';
import 'package:catalog/pages/product_detaile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String categoryId;
  const HomeScreen({super.key, required this.categoryId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>>? _finalProductData;

  final fireStore =
      FirebaseFirestore.instance.collection("categories").snapshots();

  @override
  void initState() {
    super.initState();
    getProductData();
  }

  void getProductData() async {
    try {
      CollectionReference collectionref =
          FirebaseFirestore.instance.collection("Product");
      QuerySnapshot querySnapshot = await collectionref.get();

      List<Map<String, dynamic>> getAllProductData =
          querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      _finalProductData = getAllProductData
          .where((val) => val['CatagoryId'] == widget.categoryId.toString())
          .toList();
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scafflodKey,
      appBar: MyAppBar(
          // onMenuPressed: () {
          //   _scafflodKey.currentState?.openEndDrawer();
          // }
          ),
      body: Container(
        color: const Color.fromARGB(179, 235, 226, 226),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: _finalProductData?.length,
          itemBuilder: (context, index) {
            // heroId = colorArr[index].toString();
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => pDetaile(
                            detailePageId: _finalProductData?[index]["Id"])));
              },
              // child: Hero(
              //   tag: colorArr[index].toString(),
              child: Padding(
                padding: const EdgeInsets.all(4.5),
                child: Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          _finalProductData?[index]["ImageURL"] ??
                              // "https://raw.githubusercontent.com/Codelessly/FlutterLoadingGIFs/master/packages/cupertino_activity_indicator_large.gif",
                              "https://dev-to-uploads.s3.amazonaws.com/i/mrvsmk2pl3l8fwocbfhy.gif",
                          height: 110,
                          width: 120,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${_finalProductData?[index]["Price"] ?? ""}",
                          style: const TextStyle(fontSize: 20),
                        ),
                        Text(
                          "${_finalProductData?[index]["Name"] ?? ""}",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ),
            );
          },
        ),
      ),
      endDrawer: CardDrawer(),
    );
  }
}
