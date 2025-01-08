import 'package:catalog/utils/util.dart';
import 'package:catalog/widgets/button_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

final List _categoriesDataList = [];
String _dropdonValue = "";

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  @override
  void dispose() {
    super.dispose();
    _categoriesDataList.clear();
    _dropdonValue = '';
  }

  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  bool pickImageWOnNetwork = false;

  TextEditingController nameController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  // File? pickedImage;
  String? imageUrl;
  addToflutterStorage(String name, String desc, String price) async {
    if (_dropdonValue == "" ||
        imageUrl == null ||
        name.isEmpty ||
        desc.isEmpty ||
        price.isEmpty) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Enter Required Fields",
                style: TextStyle(fontSize: 20),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            );
          });
    } else {
      try {
        setState(() {
          loading = true;
        });
        // UploadTask UploasTask = FirebaseStorage.instance
        //     .ref("/prodect pic")
        //     .child("product fic uploadiong")
        //     .putFile(pickedImage!);

        // TaskSnapshot taskSnapshot = await UploasTask;

        // String url = await taskSnapshot.ref.getDownloadURL();
        String id = DateTime.now().millisecondsSinceEpoch.toString();
        FirebaseFirestore.instance.collection("Product").doc(id).set({
          "Id": id,
          "Name": name,
          "Desc": desc,
          "Price": int.parse(price),
          "ImageURL": imageUrl,
          // "Image": url
          "CatagoryId": _dropdonValue
        }).then((value) {
          Util().toastMessage("uploading successfully");
          setState(() {
            nameController.clear();
            descriptionController.clear();
            imageUrl = null;
            priceController.clear();
            loading = false;
          });
          // ignore: avoid_types_as_parameter_names
        }).onError((e, StackTrace) {
          Util().toastMessage(e.toString());
          setState(() {
            loading = false;
          });
        });
      } catch (e) {
        debugPrint(e.toString());
        Util().toastMessage(e.toString());
        setState(() {
          loading = false;
        });
      }
    }
  }

// check image format
  Future<void> getImageFormat(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      if (response.headers.containsKey('content-type')) {
        String? contentType = response.headers['content-type'];
        if (contentType != null) {
          if (contentType.contains('image/jpeg')) {
            debugPrint('The image is in JPG format');
            setState(() {});
          } else if (contentType.contains('image/png')) {
            debugPrint('The image is in PNG format');
            setState(() {});
          } else if (contentType.contains('image/gif')) {
            debugPrint('The image is in GIF format');
            setState(() {});
          } else if (contentType.contains('image/webp')) {
            debugPrint('The image is in WebP format');
            setState(() {});
          } else {
            debugPrint('Unknown image format: $contentType');
            Util().toastMessage('Unknown image format: $contentType');
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching headers: $e');
      Util().toastMessage(e.toString());
    }
  }

  showAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: AlertDialog(
              title: const Text("Pick Image From"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    onTap: () {
                      pickImage(ImageSource.camera);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.camera_alt),
                    title: const Text("Camera"),
                  ),
                  ListTile(
                    onTap: () {
                      pickImage(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                    leading: const Icon(Icons.image),
                    title: const Text("Gallery"),
                  ),
                  ListTile(
                    onTap: () {
                      pickImageWOnNetwork = true;
                      Navigator.pop(context);
                      showAlertBox();
                    },
                    leading: const Icon(Icons.link_outlined),
                    title: const Text("From Network"),
                  ),
                  Visibility(
                    visible: pickImageWOnNetwork,
                    child: TextFormField(
                        controller: urlController,
                        // keyboardType: TextInputType.string,
                        decoration: const InputDecoration(
                          hintText:
                              "EX : https://www.google.com/imgres?car.jpg",
                          labelText: "Image URL",
                        )),
                  )
                ],
              ),
              actions: [
                Visibility(
                  visible: pickImageWOnNetwork,
                  child: TextButton(
                      onPressed: () {
                        pickImageWOnNetwork = false;
                        // setState(() {
                        imageUrl = urlController.text.toString();
                        // });
                        debugPrint(imageUrl);
                        getImageFormat(imageUrl!);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "OK",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      showAlertBox();
                    },
                    child:
                        // pickedImage != null
                        imageUrl != null
                            ? CircleAvatar(
                                radius: 80,
                                backgroundImage: NetworkImage(
                                  imageUrl!,
                                ))
                            : const CircleAvatar(
                                radius: 80,
                                child: Icon(
                                  Icons.person,
                                  size: 80,
                                ),
                              ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      controller: nameController,
                      maxLength: 20,
                      decoration: const InputDecoration(
                          hintText: "Enter item Name",
                          labelText: "Name",
                          border: OutlineInputBorder(),
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5))),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Name cannot be empty.";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      maxLines: 7,
                      minLines: 2,
                      decoration: const InputDecoration(
                          hintText: "Enter item Description",
                          labelText: "Description",
                          border: OutlineInputBorder(),
                          fillColor: Colors.black,
                          focusColor: Colors.black,
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1.5))),
                      validator: (value) {
                        if (value.toString().isEmpty) {
                          return "Item description cannot be empty.";
                        }
                        return null;
                      }),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: TextFormField(
                            controller: priceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                labelText: "Price",
                                hintText: "ex:19999.0",
                                border: OutlineInputBorder(),
                                fillColor: Colors.black,
                                focusColor: Colors.black,
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1.5))),
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Price cannot be empty.";
                              }
                              return null;
                            }),
                      ),
                      Container(
                          width: 150,
                          padding: const EdgeInsets.only(left: 10.0),
                          child: const _DropdownMenuForCategoties()),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ButtonWidget(
                        title: "Add Produt",
                        loading: loading,
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          if (_formkey.currentState!.validate()) {
                            addToflutterStorage(
                                nameController.text.toString(),
                                descriptionController.text.toString(),
                                priceController.text.toString());
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  pickImage(ImageSource imageSource) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageSource);
      if (photo == null) return;

      // final tempImage = File(photo.path);

      // setState(() {
      //   pickedImage = tempImage;
      // });
    } catch (e) {
      debugPrint(e.toString());
      Util().toastMessage(e.toString());
    }
  }
}

class _DropdownMenuForCategoties extends StatefulWidget {
  const _DropdownMenuForCategoties({super.key});

  @override
  State<_DropdownMenuForCategoties> createState() =>
      __DropdownMenuForCategotiesState();
}

class __DropdownMenuForCategotiesState
    extends State<_DropdownMenuForCategoties> {
  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  void getCategoryData() async {
    try {
      CollectionReference collectionref =
          FirebaseFirestore.instance.collection("categories");

      QuerySnapshot querySnapshot = await collectionref.get();

      // _categoriesDataList = querySnapshot.docs.map((doc) {
      //   return doc.data() as Map<String, dynamic>;
      // }).toList();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _categoriesDataList.add(data);
      }
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // final List categoriesList = [
  //   {"title": "Fashion", "value": "fashionCategoies"},
  //   {"title": "Electronics", "value": "electronicsCategorie"},
  // ];
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: "Category",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        contentPadding: const EdgeInsets.all(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            isDense: true,
            value: _dropdonValue,
            menuMaxHeight: 350,
            isExpanded: true,
            items: [
              const DropdownMenuItem(
                value: "",
                child: Text(
                  "Select Category",
                ),
              ),
              ..._categoriesDataList.map<DropdownMenuItem<String>>((val) {
                return DropdownMenuItem(
                    value: val['id'], child: Text(val['name']));
              }),
            ],
            onChanged: (value) {
              debugPrint(value);
              setState(() {
                _dropdonValue = value!;
              });
            }),
      ),
    );
  }
}
