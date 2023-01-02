import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

import '../../Utils/constants.dart';
import '../../provider/User/user_topup_provider.dart';
import '../../provider/Vehicle/vehicles_categories_provider.dart';
import '../components/bottomnavigationscreen.dart';

class MySellingScreen extends StatefulWidget {
  const MySellingScreen({Key? key}) : super(key: key);

  @override
  _MySellingScreenStates createState() => _MySellingScreenStates();
}

class _MySellingScreenStates extends State {
  var postLeftCounter = 0;
  var myPostCounter = 0;
  var isFormVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        title: const Text(
          "New Post",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => TabsPage(),
                ),
                    (route) => false);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          var test = snapshot.data!.docs;
          for (var i in test) {
            var dummy = i.data() as Map<String, dynamic>;
            // print(dummy);
            if (dummy['uid'] == cUser().uid) {
              Provider.of<UserProvider>(context, listen: false)
                  .saveMaxSellCount(dummy['maxSellCount']);
            }
          }
          postLeftCounter =
              Provider.of<UserProvider>(context, listen: false).getSellMaxCount;
          return Column(children: [
            const SizedBox(height: 4),
            //Card Post Indicator
            Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 2,
                  color: Colors.greenAccent[100],
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(children: [
                      Row(children: [
                        const SizedBox(width: 16),
                        Text(
                          "$postLeftCounter post left",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              fontFamily: 'SEGOEUI',
                              color: Colors.black),
                        ),
                        const Spacer(),

                        //TOPUP Button
                        // ElevatedButton(
                        //     style: ElevatedButton.styleFrom(
                        //         primary: Colors.green[600]),
                        //     onPressed: () {
                        //       openPlansDialog(context);
                        //     },
                        //     child: const Text(
                        //       'TOPUP',
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold,
                        //         fontFamily: 'SEGOEUI',
                        //         color: Colors.white,
                        //       ),
                        //     )),
                      ]),
                    ]),
                  ),
                )),

            //New post
            const Expanded(
              child: AddNewPost(),
            )
          ]);
        },
      ),
    );
  }

  openPlansDialog(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Plan',
              style: TextStyle(
                fontFamily: 'SEGOEUI',
                fontWeight: FontWeight.bold,
                fontSize: 34,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.cancel,
              ),
            ),
          ],
        ),
        content: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(204, 103, 7, 1)),
                onPressed: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '2',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          fontFamily: 'SEGOEUI',
                          color: Colors.white),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        'Posts',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            fontFamily: 'SEGOEUI',
                            color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '19 ₹',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          fontFamily: 'SEGOEUI',
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(49, 97, 254, 1)),
                onPressed: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      '5',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          color: Colors.white),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                      child: const Text(
                        'Posts',
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            fontFamily: 'SEGOEUI',
                            color: Colors.white),
                      ),
                    ),
                    const Spacer(),
                    const Text(
                      '39 ₹',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 34,
                          fontFamily: 'SEGOEUI',
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(41, 171, 12, 1)),
                  onPressed: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '7',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            color: Colors.white),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        child: const Text(
                          'Posts',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 18,
                              fontFamily: 'SEGOEUI',
                              color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        '59 ₹',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 34,
                            fontFamily: 'SEGOEUI',
                            color: Colors.white),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class AddNewPost extends StatefulWidget {
  const AddNewPost({Key? key}) : super(key: key);

  @override
  _AddNewPostStates createState() => _AddNewPostStates();
}

class _AddNewPostStates extends State {
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
    setState(() {});
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
  String transmissionvalue = '   Transmission Mode';
  var transmissiontypes = [
    '   Transmission Mode',
    '   Manual',
    '   Auto',
  ];

  int runtimeState = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                        child: Image.file(
                          selectedFiles[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                        : const Icon(
                      Icons.add_photo_alternate,
                      size: 35,
                    ),
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
                          setState(() {
                            dropdownBrandvalue = 'Select Brand';
                          });
                          setState(() {
                            selectedCategory = categoryData.firstWhere(
                                    (element) => element['title'] == value);
                            dropdowncategoryvalue = value!;
                            selectedCategoryId = categoryId.firstWhere(
                                    (element) => element['title'] == value)['id'];
                          });

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
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),

                //Select Brand
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

                //Transmission
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: DropdownButton(
                    underline: const SizedBox(),
                    isExpanded: true,
                    value: transmissionvalue,
                    items: transmissiontypes
                        .map((e) => DropdownMenuItem(child: Text(e), value: e))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        isTransmissionEmpty = false;
                        transmissionvalue = value!;
                      });
                    },
                  ),
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
                      if (Provider.of<UserProvider>(context, listen: false)
                          .getSellMaxCount ==
                          0) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            scrollable: true,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Select Plans',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 34,
                                    fontFamily: 'SEGOEUI',
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(
                                    Icons.cancel,
                                  ),
                                ),
                              ],
                            ),
                            content: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.orange),
                                    onPressed: () {},
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          '2',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 34,
                                              fontFamily: 'SEGOEUI',
                                              color: Colors.white),
                                        ),
                                        Container(
                                          margin:
                                          const EdgeInsets.only(bottom: 5),
                                          child: const Text(
                                            'Posts',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                                fontFamily: 'SEGOEUI',
                                                color: Colors.white),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text(
                                          '19 ₹',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 34,
                                              fontFamily: 'SEGOEUI',
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue[900]),
                                    onPressed: () {},
                                    child: Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                          '5',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 34,
                                              fontFamily: 'SEGOEUI',
                                              color: Colors.white),
                                        ),
                                        Container(
                                          margin:
                                          const EdgeInsets.only(bottom: 5),
                                          child: const Text(
                                            'Posts',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                                fontFamily: 'SEGOEUI',
                                                color: Colors.white),
                                          ),
                                        ),
                                        const Spacer(),
                                        const Text(
                                          '39 ₹',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 34,
                                              fontFamily: 'SEGOEUI',
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.green[800]),
                                      onPressed: () {},
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                            '7',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 34,
                                                fontFamily: 'SEGOEUI',
                                                color: Colors.white),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 5),
                                            child: const Text(
                                              'Posts',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  fontFamily: 'SEGOEUI',
                                                  color: Colors.white),
                                            ),
                                          ),
                                          const Spacer(),
                                          const Text(
                                            '59 ₹',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 34,
                                                fontFamily: 'SEGOEUI',
                                                color: Colors.white),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (isImageEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Select an Image')));
                        } else if (isBrandEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter Brand')));
                        } else if (isStateEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Select State')));
                        } else if (isCityEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter City')));
                        } else if (isVehicleEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter vehicle')));
                        } else if (isModelEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter Model')));
                        } else if (isKmDrivenEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter Km Driven')));
                        } else if (isOwnerNoEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Enter Number of owners')));
                        } else if (isFuelTypeEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter Fuel type')));
                        } else if (isDescriptionTextEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Enter Description')));
                        } else if (isSellAmountEmpty) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Enter Price')));
                        } else {
                          savePost();
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Post Saved "),
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
                        }
                      }
                    },
                    child: const Text(
                      'POST',
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
        ));
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

  void savePost() async {
    var vi = Provider.of<CategoriesProvider>(context, listen: false)
        .getCatergoryId(dropdowncategoryvalue);
    Map<String, dynamic> obj = {
      'image': savedUrl,
      'kmDriven': kmsController.text.trim(),
      'sellAmount': double.parse(priceController.text.trim()),
      'descriptionText': descriptionController.text.trim(),
      'vehicle': dropdownModelvalue,
      'ownerNo': dropownervalue,
      'place': "${cityController.text.trim()}" + " " + dropdownStatevalue,
      'fuelType': dropdownfueltypevalue,
      'title': dropdownBrandvalue + ' ' + dropdownModelvalue,
      'vehicleType': dropdowncategoryvalue,
      'yearModel': dropdownmodelvalue + ' model',
      'vehicleId': vi,
      'itemBy': cUser().uid,
      'itemByName': cUser().displayName,
      'chache': '',
      'brand': dropdownBrandvalue,
      'status': "PENDING",
      'postNo': 0,
      'dateTime': DateTime.now()
    };

    await FirebaseFirestore.instance.collection('vehicle_database').add(obj);
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(selectedCategoryId)
        .set(selectedCategory);
    updateSellMaxCount();
  }

  void updateSellMaxCount() {
    Provider.of<UserProvider>(context, listen: false).decreaseMaxSellCount();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getAddressFromLatLong(Position loc) async {
    List<Placemark> dummy =
    await placemarkFromCoordinates(loc.latitude, loc.longitude);
    Placemark place = dummy[0];
    await FirebaseFirestore.instance
        .collection('places')
        .doc(place.locality)
        .set({
      'place': place.locality,
    });
    return place.locality!;
  }
}
