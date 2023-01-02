import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

import '../../Utils/constants.dart';
import '../../models/Core_Model/vehicle_data_model.dart';
import '../../provider/User/user_topup_provider.dart';
import '../components/bottomnavigationscreen.dart';

class EditVehicle extends StatefulWidget {
  final VehicleModel currentVehicle;
  const EditVehicle({Key? key,required this.currentVehicle}) : super(key: key);

  @override
  State<EditVehicle> createState() => _EditVehicleState();
}

class _EditVehicleState extends State<EditVehicle> {
  //Empty Indicators
  String url = '';
  bool isImageEmpty = true;
  bool isKmDrivenEmpty = true;
  bool isSellAmountEmpty = true;
  bool isDescriptionTextEmpty = true;
  bool isVehicleEmpty = true;
  bool isOwnerNoEmpty = true;
  bool isTransmissionEmpty = true;
  bool isFuelTypeEmpty = true;
  bool isTitleEmpty = true;
  bool isBrandEmpty = true;
  bool isModelEmpty = true;
  bool isCityEmpty = true;
  bool isStateEmpty = true;
  List<File> selectedFiles = [];
  List<String> savedUrl = [];

  //Values & function for Brand DropDown
  final _brandref =
  FirebaseFirestore.instance.collection('info_vehicle').doc('brand');
  List<dynamic> getBrandList = [];
  List<String> brandDataList = [];

  Future<void> getBrandData() async {
    print("Get function called");
    var brandData = await _brandref.get();
    var fieldData = brandData.get("allBrand");
    getBrandList = fieldData;

    setState(() {});
    brandDataList = getBrandList.map((e) => e.toString()).toList();
  }

  List<dynamic> docIDDemo = [];

  //Values & function for Category DropDown
  int runtimeCategory = 0;
  List<String> categoryDataList = [
    'Select Category',
  ];

  // Initial Category Value
  String dropdownCategoryvalue = 'Select Category';
  String categoryID = 'AZGOUnNt2hYgBhjzRewN';

  // Initial Brand Value
  String dropdownBrandvalue = 'Select Brand';

  List<dynamic> brandDocIDDemo = [];
  List<String> brandDocIDs = [];

  List<dynamic> brandTitlesDemo = [
    'Select Brand',
  ];
  List<String> brandTitles = [
    'Select Brand',
  ];

  Future<void> getBrandTitles() async {
    print("Get function called");
    setState(() {
      if (brandTitlesDemo.length >= 1) {
        brandTitlesDemo = [
          'Select Brand',
        ];

        print('If Else working $brandTitlesDemo');
      }
    });
    await FirebaseFirestore.instance
        .collection('Brand')
        .where('CategoryId', isEqualTo: categoryID)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
          brandTitlesDemo.add(document.get('Name'));
          setState(() {});

          brandTitles = brandTitlesDemo.map((e) => e.toString()).toList();
          print("Function data:- $brandTitles");
        },
      ),
    );
  }

  // Brand and Category dropdown values end

  //Values & function for Brand DropDown

  String brandID = '';

  // Initial Brand Value
  String dropdownModelvalue = 'Select Model';

  List<dynamic> modelDocIDDemo = [];
  List<String> modelDocIDs = [];

  List<dynamic> modelTitlesDemo = [
    'Select Model',
  ];
  List<String> modelTitles = [
    'Select Model',
  ];

  Future<void> getModelTitles() async {
    print("Brand Id $brandID");
    print("Get function called");
    setState(() {
      if (modelTitlesDemo.length >= 1) {
        modelTitlesDemo = [
          'Select Model',
        ];

        print('If Else working $modelTitlesDemo');
      }
    });
    await FirebaseFirestore.instance
        .collection('Model')
        .where('BrandId', isEqualTo: brandID)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
          modelTitlesDemo.add(document.get('Name'));
          setState(() {});

          modelTitles = modelTitlesDemo.map((e) => e.toString()).toList();
          print("Function data of models:- $modelTitles");
        },
      ),
    );
    print("Namee of model $modelTitles ");
  }

  //Values & function for vehicle DropDown
  final _vehicleref =
  FirebaseFirestore.instance.collection('info_vehicle').doc('vehicle');
  List<dynamic> getVehicleList = [];
  List<String> vehicleDataList = [];

  Future<void> getVehicleData() async {
    print("vehicleGet function called");
    var vehicleData = await _vehicleref.get();
    var vehicleFieldData = vehicleData.get('Bajaj');
    getVehicleList = vehicleFieldData;
    print("vehicleData :- $vehicleData");
    setState(() {});
    vehicleDataList = getVehicleList.map((e) => e.toString()).toList();
    print(vehicleDataList);
  }

  // Initial Brand Value
  late String dropdownVehiclevalue = vehicleDataList.elementAt(0);

  //Values & function for State DropDown
  List<String> stateDataList = [
    'Select State',
  ];

  // Initial State Value
  String dropdownStatevalue = 'Select State';
  String stateID = 'AZGOUnNt2hYgBhjzRewN';

  @override
  void initState() {
    super.initState();
    getBrandData();
    getVehicleData();
    updateValues();
    brandTitles = [
      'Select Brand',
    ];
    print("Now Calling");
    print(brandTitlesDemo);
    setState(() {});

    FirebaseFirestore.instance
        .collection('categories')
        .where('title', isEqualTo: dropdowncategoryvalue)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
          print(document.reference);
          categoryID =
              document.reference.id.toString();
          print(document.reference.id);
          setState(() {});
          print("Category ID is:- $categoryID");
          getBrandTitles();
        },
      ),
    );
  }

  Future<void> updateValues()async{
    kmsController = TextEditingController(text: widget.currentVehicle.kmDriven);
    descriptionController = TextEditingController(text: widget.currentVehicle.descriptionText);
    priceController = TextEditingController(text: widget.currentVehicle.sellAmount.toString());
    dropdowncategoryvalue = widget.currentVehicle.vehicleType;
    dropdownBrandvalue = widget.currentVehicle.brand;
    dropdownvehiclesvalue = widget.currentVehicle.vehicle;
    dropdownfueltypevalue = widget.currentVehicle.fuelType;
    dropdownmodelvalue = widget.currentVehicle.yearModel;
    dropownervalue = widget.currentVehicle.ownerNo;
    savedUrl = widget.currentVehicle.image.map((e) => e.toString()).toList();
  }

  //Helpers
  TextEditingController descriptionController = TextEditingController();
  TextEditingController kmsController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  String dropdownbrandvalue = '   Brand';
  List<String> brandItems = [];

  late Map<String, dynamic> selectedBrand;

  String dropdownmodelvalue = '   Model';

  List<String> vehicleItems = [];
  late Map<String, dynamic> selectedVehicle;
  String dropdownvehiclesvalue = '   Vehicles';

  String dropdowncategoryvalue = '   Category';
  List<String> categoryItems = [];
  late Map<String, dynamic> selectedCategory;
  late String selectedCategoryId;
  String dropdownfueltypevalue = '   FuelType';
  var fueltypeItems = [
    '   FuelType',
    '   Petrol',
    '   Diesel',
    '   Electric',
    '   CNG and Hybrid',
  ];
  String dropownervalue = '   Number Of Owners';
  var ownerItem = [
    '   Number Of Owners',
    '   1',
    '   2',
    '   3',
    '   4',
    '   4+',
  ];


  int runtimeState = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "Edit Post",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //       builder: (context) => TabsPage(),
            //     ),
            //         (route) => false);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Images (Max 3)',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'SEGOEUI',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: _takeImageFromLibrary,
                    child: Container(
                        height: 200,
                        width: double.maxFinite,
                        color: Colors.grey[300],
                        child: (selectedFiles.isNotEmpty)
                            ? ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedFiles.length,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: MediaQuery.of(context).size.width,
                            child:  Image.file(
                              selectedFiles[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                            : widget.currentVehicle.image.length == 0 ? Icon(
                          Icons.add_photo_alternate,
                          size: 35,
                        ) : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.currentVehicle.image.length,
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: MediaQuery.of(context).size.width,
                            child:  Image.network(widget.currentVehicle.image[index]),
                          ),
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
//Category
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .orderBy("id")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var categoryList = snapshot.data!.docs;
                      categoryItems = ['   Category'];
                      var categoryData = [];
                      var categoryId = [];
                      for (var element in categoryList) {
                        categoryData.add(element.data());
                        categoryItems.add(element['title']);
                        categoryId
                            .add({'id': element.id, 'title': element['title']});
                      }
                      return Container(
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: DropdownButton(
                          underline: const SizedBox(),
                          isExpanded: true,
                          value: dropdowncategoryvalue,
                          items: categoryItems
                              .map((e) =>
                              DropdownMenuItem(child: Text(e), value: e))
                              .toList(),
                          onChanged: (String? value) {
                            // setState(() {
                            //   dropdownBrandvalue = 'Select Brand';
                            // });

                          },
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Brand')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      print(categoryDataList);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: categoryDataList == null
                            ? CircularProgressIndicator()
                            : Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            isExpanded: true,
                            // Initial Value
                            value: dropdownBrandvalue,
                            items: brandTitles.map((String dataList) {
                              return DropdownMenuItem(
                                value: dataList,
                                child: Text(dataList),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownModelvalue = 'Select Model';
                              });
                              setState(() {
                                isBrandEmpty = false;
                                dropdownBrandvalue = newValue!;
                              });

                              modelTitles = [
                                'Select Model',
                              ];
                              print("Now Calling");
                              print(modelTitlesDemo);
                              setState(() {});

                              FirebaseFirestore.instance
                                  .collection('Brand')
                                  .where('Name',
                                  isEqualTo: dropdownBrandvalue)
                                  .get()
                                  .then(
                                    (snapshot) => snapshot.docs.forEach(
                                      (document) {
                                    print(document.reference);
                                    brandID = document.reference.id
                                        .toString();
                                    print(document.reference.id);
                                    setState(() {});
                                    print("Brand ID is:- $brandID");
                                    getModelTitles();
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Model')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      print(brandTitles);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: brandTitles == null
                            ? CircularProgressIndicator()
                            : Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            isExpanded: true,
                            // Initial Value
                            value: dropdownModelvalue,
                            items: modelTitles.map((String dataList) {
                              return DropdownMenuItem(
                                value: dataList,
                                child: Text(dataList),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                isVehicleEmpty = false;
                                dropdownModelvalue = newValue!;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //FUEL TYPE
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: DropdownButton(
                      underline: const SizedBox(),
                      isExpanded: true,
                      value: dropdownfueltypevalue,
                      items: fueltypeItems
                          .map((e) => DropdownMenuItem(child: Text(e), value: e))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          isFuelTypeEmpty = false;
                          dropdownfueltypevalue = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  // // model
                  GestureDetector(
                    onTap: () async {
                      final todayDate = DateTime.now();
                      final selected = await showMonthYearPicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2008),
                          lastDate: DateTime(2200));
                      print(selected!.year);
                      setState(() {
                        dropdownmodelvalue = selected!.year.toString();
                        isModelEmpty = false;
                      });
                    },
                    child: Container(
                        height: 50,
                        padding: const EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: Row(
                          children: [
                            Text(dropdownmodelvalue),
                            const Icon(Icons.arrow_drop_down)
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Number of owner
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: DropdownButton(
                      underline: const SizedBox(),
                      isExpanded: true,
                      value: dropownervalue,
                      items: ownerItem
                          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (String? value) {
                        setState(() {
                          isOwnerNoEmpty = false;
                          dropownervalue = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),


                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('State')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      runtimeState++;
                      if (runtimeState == 1) {
                        for (var i = 0; i < snapshot.data!.docs.length; i++) {
                          stateDataList.add(snapshot.data!.docs[i].get("Name"));
                          stateDataList.sort();
                        }
                      }

                      print(stateDataList);
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        child: stateDataList == null
                            ? CircularProgressIndicator()
                            : Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: DropdownButton(
                            underline: const SizedBox(),
                            isExpanded: true,
                            // Initial Value
                            value: dropdownStatevalue,
                            items: stateDataList.map((String dataList) {
                              return DropdownMenuItem(
                                value: dataList,
                                child: Text(dataList),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              print(" State data list is -$stateDataList");

                              setState(() {
                                isStateEmpty = false;
                                dropdownStatevalue = newValue!;
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),


                  //City
                  isStateEmpty ? SizedBox() : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          border: Border.all(color: Colors.black)),
                      child: TextField(
                        controller: cityController,
                        onChanged: (_) {
                          setState(() {
                            isCityEmpty = false;
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 15,
                          ),
                          labelText: 'City',
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                          errorBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  //KMS dialog
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.black)),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (_) {
                        setState(() {
                          isKmDrivenEmpty = false;
                        });
                      },
                      controller: kmsController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        isDense: true,
                        labelText: 'KMS Ridden',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Description Box
                  Container(
                    width: double.infinity,
                    //height: 200,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.black)),
                    child: TextField(
                      onChanged: (_) {
                        setState(() {
                          isDescriptionTextEmpty = false;
                        });
                      },
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15),
                        labelText: 'Description',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                      maxLength: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  //Price

                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.black)),
                    child: TextField(
                      keyboardType: TextInputType.phone,
                      onChanged: (_) {
                        setState(() {
                          isSellAmountEmpty = false;
                        });
                      },
                      controller: priceController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 15,
                        ),
                        labelText: 'Price',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                        errorBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //Post Button
                  SizedBox(
                    height: 36,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.deepPurple),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Are your sure?"),

                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("Cancle"),
                                  ),TextButton(
                                    onPressed: () {

                                      updatePost();
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              );
                            });

                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Post Updated "),
                                content: const Text(
                                    'Let our team review your post, After approval your post will publish. '),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                TabsPage(),
                                          ),
                                              (route) => false);
                                    },
                                    child: const Text("OK"),
                                  )
                                ],
                              );
                            });
                      },


                      child: const Text(
                        'Update',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SEGOEUI',
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
  _takeImageFromLibrary() async {
    try {
      var imageProvider = ImagePicker();
      var img = await imageProvider.pickMultiImage();
      //Create a reference to the location you want to upload to in firebase
      List<File> dummy = [];
      img!.forEach((element) {
        dummy.add(File(element.path));
      });
      saveImages(dummy);
      setState(() {
        selectedFiles = dummy;
        isImageEmpty = false;
      });
      print(selectedFiles.length);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Success')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void saveImages(List<File> dummy) async {
    var sellCount =
        Provider.of<UserProvider>(context, listen: false).getSellMaxCount;
    var counter = 1;
    for (var element in dummy) {
      TaskSnapshot snapshot = await FirebaseStorage.instance
          .ref()
          .child('${cUser().uid}/$sellCount/$counter.jpg')
          .putFile(element);
      counter++;
      if (snapshot.state == TaskState.success) {
        final String url = await snapshot.ref.getDownloadURL();
        savedUrl.add(url);
      }
    }
  }

  void updatePost() async {
    Map<String, dynamic> obj = {
      'image': savedUrl,
      'kmDriven': kmsController.text.trim(),
      'sellAmount': double.parse(priceController.text.trim()),
      'descriptionText': descriptionController.text.trim(),
      'vehicle': dropdownvehiclesvalue,
      'ownerNo': dropownervalue,
      'fuelType': dropdownfueltypevalue,
      'title': dropdownBrandvalue + ' ' + dropdownvehiclesvalue,
      'yearModel': dropdownmodelvalue + ' model',
      'brand': dropdownBrandvalue,
      'status': "PENDING",
    };
    await FirebaseFirestore.instance.collection('vehicle_database').doc(widget.currentVehicle.dbId).update(obj);
  }
}