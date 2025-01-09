import 'package:catalog/pages/categories_screen.dart';
import 'package:catalog/provider/cardItemCountProvider.dart';
import 'package:catalog/utils/util.dart';
import 'package:catalog/widgets/appbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardDrawer extends StatefulWidget {
  const CardDrawer({super.key});

  @override
  State<CardDrawer> createState() => _CardDrawerState();
}

class _CardDrawerState extends State<CardDrawer> {
  List<Map<String, dynamic>>? _cardData;
  double? PRICEAMOUNT;
  double PLATFORMFREE = 5.0;
  double DECRG = 80.0;
  double? TOTALAMOUNT;
  // bool loa
  // final _firestore = FirebaseFirestore.instance;
  final CollectionReference _collectionref =
      FirebaseFirestore.instance.collection('cardCatalog');
  @override
  void initState() {
    super.initState();
    getCardItems();
  }

  void getCardItems() async {
    try {
      // CollectionReference _collectionref =
      //     FirebaseFirestore.instance.collection('cardCatalog');

      QuerySnapshot querySnapshot = await _collectionref.get();

      _cardData = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      PRICEAMOUNT = 000.00;
      TOTALAMOUNT = 000.00;
      for (var val in _cardData!) {
        PRICEAMOUNT = PRICEAMOUNT! + val['Price'] * val['Quality'];
      }
      TOTALAMOUNT = PRICEAMOUNT! + PLATFORMFREE + DECRG;
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deleteCardItem(String docid, int qtly) async {
    try {
      _collectionref.doc(docid).delete().then((value) {
        context.read<CountItemOfCardProvider>().removeCardItemCount(qtly);
        Util().toastMessage("remove card item");
      }).onError((e, StackTrace) {
        Util().toastMessage(e.toString());
      });
      getCardItems();
      // setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: const Color.fromARGB(210, 236, 236, 236),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  "My Cart",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
              ),
              const Divider(),
              Expanded(
                // ignore: prefer_is_empty
                child: _cardData?.length != 0
                    ? ListView.builder(
                        itemCount: _cardData?.length,
                        itemBuilder: (BuildContext context, index) {
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(5.0),
                              child: Image.network(
                                _cardData?[index]["ImageURL"] ??
                                    "https://dev-to-uploads.s3.amazonaws.com/i/mrvsmk2pl3l8fwocbfhy.gif",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              _cardData?[index]['Name'] ?? "",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                            subtitle: Row(
                              children: [
                                // ignore: prefer_const_constructors
                                Icon(
                                  Icons.currency_rupee_sharp,
                                  color: Colors.blueGrey,
                                  size: 20,
                                ),
                                Text(
                                  "${_cardData?[index]['Price'] ?? ""}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Colors.blue.shade400),
                                ),
                                const SizedBox(width: 5),
                                const Text("quality : ",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.90)),
                                Text("${_cardData?[index]['Quality'] ?? ""}",
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () {
                                deleteCardItem(_cardData?[index]['Id'],
                                    _cardData?[index]['Quality']);
                                // Scaffold.of(context).closeEndDrawer();
                                // Scaffold.of(context).openEndDrawer();
                              },
                              child: const Icon(
                                Icons.close,
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Your card is Empty"),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Categoris()));
                                },
                                child: const Text("Click here for Shopping"))
                          ],
                        ),
                      ),
              ),
              const Divider(),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Price Details",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          _PriceDetails(
                              "Price (4 items)", PRICEAMOUNT ?? 00.00),
                          _PriceDetails("Platform Fee", 5),
                          _PriceDetails("Delivery Charges", 80),
                          const Divider(),
                          _PriceDetails(
                            "Total Amount",
                            TOTALAMOUNT ?? 00.00,
                            isBold: true,
                          )
                        ],
                      ),
                    ),
                  ),
                  PlaceOrderBtn(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _PriceDetails(String nameOfDetails, double rupees,
      {bool isBold = false}) {
    // bool isBold = false;
    return Padding(
      padding: const EdgeInsets.only(
        top: 3.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isBold
              ? Text(
                  nameOfDetails,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      fontSize: 17),
                )
              : Text(nameOfDetails),
          Row(
            children: [
              const Icon(
                Icons.currency_rupee_sharp,
                size: 17,
              ),
              Text(
                // ignore: prefer_is_empty
                _cardData?.length == 0 ? "${00.00}" : "$rupees",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class PlaceOrderBtn extends StatelessWidget {
  const PlaceOrderBtn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Util().toastMessage("Payment Process comming soon...");
          },
          style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
              shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))))),
          child: const Text(
            "Place order",
            style: TextStyle(
                color: Colors.white, fontSize: 17, letterSpacing: 2.0),
          ),
        ),
      ),
    );
  }
}
