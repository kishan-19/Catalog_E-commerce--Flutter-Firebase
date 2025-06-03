import 'package:catalog/provider/cardItemCountController.dart';
import 'package:catalog/utils/util.dart';
import 'package:catalog/widgets/appbar.dart';
import 'package:catalog/widgets/card_drawer.dart';
import 'package:catalog/provider/counterProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class pDetaile extends StatefulWidget {
  // const pDetaile({super.key});
  final String detailePageId;
  const pDetaile({super.key, required this.detailePageId});

  @override
  State<pDetaile> createState() => _pDetaileState();
}

Map<String, dynamic>? __prodectdata;
int? __qlty;

// ignore: camel_case_types
class _pDetaileState extends State<pDetaile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool loading = false;
  final Carditemacountcontroller cardItemController =
      Get.put(Carditemacountcontroller());
  @override
  void initState() {
    super.initState();
    fetchDocument();
  }

  Future<void> fetchDocument() async {
    try {
      setState(() {
        loading = true;
      });
      DocumentSnapshot document = await _firestore
          .collection('Product')
          .doc(widget.detailePageId)
          .get();

      if (document.exists) {
        __prodectdata = document.data() as Map<String, dynamic>?;
        setState(() {
          loading = false;
        });
      } else {
        Util().toastMessage("Loading failed");
        debugPrint("Document does not exist!");
        setState(() {
          loading = false;
        });
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint("Error fetching document: ${e.toString()}");
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: loading == false
            ? Container(
                color: const Color.fromARGB(210, 236, 236, 236),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 278,
                      color: Colors.white,
                      child: Hero(
                        tag: widget.detailePageId,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              __prodectdata?['ImageURL'] ??
                                  // "https://raw.githubusercontent.com/Codelessly/FlutterLoadingGIFs/master/packages/cupertino_activity_indicator_large.gif",
                                  "https://dev-to-uploads.s3.amazonaws.com/i/mrvsmk2pl3l8fwocbfhy.gif",
                              width: double.infinity,
                              height: 200,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    __prodectdata?['Name'] ?? "",
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${__prodectdata?['Price'] ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    pdesc(),
                    Column(
                      children: [
                        qualityOfProduct(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${__prodectdata?['Price'] ?? ""}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  addToCardItem(
                                      __prodectdata?['ImageURL'],
                                      __prodectdata?['Name'],
                                      __prodectdata?['Price'],
                                      __qlty!);
                                },
                                child: const Text(
                                  "Add to cart",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 17),
                                ),
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll<Color>(
                                            Colors.blue),
                                    shape: WidgetStatePropertyAll<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))))),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(
                child: Image.network(
                  "https://miro.medium.com/v2/resize:fit:1200/1*xAUnGJlMvI622sjInCO6Bg.gif",
                  fit: BoxFit.cover,
                  height: 660,
                  width: double.infinity,
                ),
              ),
      ),
      endDrawer: CardDrawer(),
    );
  }

  void addToCardItem(String imgURL, String name, int price, int quality) async {
    if (imgURL == '' || name == '' || price == null || quality == null) {
      Util().toastMessage("cant't add to card");
      debugPrint('any one item is null');
    } else {
      try {
        String Id = DateTime.now().microsecondsSinceEpoch.toString();
        FirebaseFirestore.instance.collection("cardCatalog").doc(Id).set({
          "Id": Id,
          "Name": name,
          "Price": price,
          "ImageURL": imgURL,
          "Quality": quality
        }).then((value) {
          // context.read<CountItemOfCardProvider>().setCardItemCount(quality);
          cardItemController.setCardItema(quality);
          Util().toastMessage("Add to card successfully");
        }).onError((e, StackTrace) {
          Util().toastMessage(e.toString());
        });
      } catch (e) {
        debugPrint(e.toString());
      }
    }
  }
}

class pdesc extends StatelessWidget {
  const pdesc({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(235, 3, 168, 244)),
          ),
          const SizedBox(height: 8),
          Text(
            __prodectdata?['Desc'] ?? "",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class qualityOfProduct extends StatelessWidget {
  const qualityOfProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "quality",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    // Provider.of<CounterProvider>(context, listen: false)
                    //     .decrementProductCount();
                    context.read<CounterProvider>().decrementProductCount();
                  },
                ),
                Consumer<CounterProvider>(builder: (ctx, Provider, __) {
                  // _pCounterValut =ctx.watch<CounterProvider>().getProductCount();
                  // ||
                  // _pCounterValut = Provider.getProductCount();
                  __qlty = Provider.getProductCount();
                  return Text(
                    // '${Provider.of<CounterProvider>(ctx, listen: true).getProductCount()}',
                    '${Provider.getProductCount()}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  );
                }),
                IconButton(
                  style: const ButtonStyle(),
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    // Provider.of<CounterProvider>(context, listen: false)
                    //     .incrementProductCount();
                    context.read<CounterProvider>().incrementProductCount();
                  },
                ),
              ],
            ),
          ],
        ));
  }
}
