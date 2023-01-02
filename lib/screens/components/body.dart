import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotbuy/screens/drawer/navigation_drawer_screen.dart';

import '../../Utils/size_config.dart';
import '../../models/Core_Model/categories_model.dart';
import '../../provider/Vehicle/vehicle_list_provider.dart';
import '../../provider/Vehicle/vehicles_categories_provider.dart';
import '../vehicle_detail_screen.dart';
import 'SearchVehicleList.dart';
import 'custom_all_categories_list.dart';
import 'custom_app_bar.dart';
import 'main_vehicle_dashboard.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  _BodyStates createState() => _BodyStates();
}

class _BodyStates extends State {
  late var search = null;

  @override
  Widget build(BuildContext context) {
    final selectedCategory =
        Provider.of<CategoriesProvider>(context).getSelectedCategory();

    return Scaffold(
      drawer: const navigationdrawer(),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(
            getProportionateScreenWidth(10),
          ),
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // customised app bar
                const CustomAppBar(),
                SizedBox(
                  height: getProportionateScreenWidth(10),
                ),

                // customised category list
                const CustomCategoriesList(),
                SizedBox(
                  height: getProportionateScreenWidth(10),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: TextFormField(
                    onChanged: (value) {
                      print(value);
                      search = value;
                      setState(() {});
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(1)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.black54,
                        ),
                        hintText: "Search vehicle",
                        hintStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                        )),
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenWidth(10),
                ),
                // selected category text
                Text(
                  search == null || search == ""
                      ? selectedCategory.name
                      : "Search Results",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionateScreenWidth(30),
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: getProportionateScreenWidth(10),
                ),
                MainVehicleList(selectedCategory: selectedCategory)

                //TODO Search functinality
                // main vehicle display list
                // search == null || search == ""
                //     ? MainVehicleList(selectedCategory: selectedCategory)
                //     : SearchVehicleList(
                //         search: search,
                //       ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VehicleList extends StatefulWidget {
  final CategoriesModel selectedCategory;
  var search;

   VehicleList({Key? key, required this.selectedCategory, this.search})
      : super(key: key);

  @override
  _VehicleListState createState() => _VehicleListState(selectedCategory,search);
}

class _VehicleListState extends State {
  final CategoriesModel selectedCategory;
  var search;

  _VehicleListState(this.selectedCategory,search){
    this.search=search;
  }

  void fetchData(List data, BuildContext context) {
    Provider.of<VehicleProvider>(context).fetchAllVehicleData(data);
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = size.height * .316;
    final double itemWidth = size.width / 2;
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
          stream: search == null || search == "" ?
              FirebaseFirestore.instance
                .collection('vehicle_database')
                .where("status", isEqualTo: 'APPROVED')
                .snapshots()
              :
              FirebaseFirestore.instance
                .collection('vehicle_database')
                .where("status", isEqualTo: 'APPROVED')
                .orderBy('title')
                .startAt(search)
                .endAt(search+"~")
                .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text(
                  "No item found!!!",
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            String truncate(String text, { length: 15, omission: '...' }) {
              if (length >= text.length) {
                return text;
              }
              return text.replaceRange(length, text.length, omission);
            }

            var data = snapshot.data!.docs;

            fetchData(data, context);

            final vehicleList = search == null || search == "" ?Provider.of<VehicleProvider>(context)
                .getVehicleById(selectedCategory.id):Provider.of<VehicleProvider>(context)
                .searchVehicle(search);
            return vehicleList.isEmpty?const Center(child:Text("No Vehicle Found!"))
                : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: (itemWidth / itemHeight),
              padding: EdgeInsets.zero,
              children: [
                for (var index = 0; index < vehicleList.length; index++)
                  index != null
                      ? SizedBox(
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VehicleDetailScreen(

                              docId: snapshot.data!.docs[index].id,
                              vehicleType: snapshot.data!.docs[index]
                                  .get('vehicleType'),
                              itemBy: snapshot.data!.docs[index]
                                  .get('itemBy'),
                            ),
                          )),
                      child: Card(
                        elevation: 5,
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 130,
                                  width: double.infinity,
                                  child: Image.network(
                                    snapshot.data!.docs[index]
                                        .get('image')[0],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data!.docs[index].get('brand')} ${snapshot.data!.docs[index].get('vehicle')}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Rs ${snapshot.data!.docs[index].get('sellAmount')}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 160,
                                      child: Row(
                                        children: [
                                          Text(
                                            "${snapshot.data!.docs[index].get('yearModel')} |",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              truncate(' ${snapshot.data!.docs[index].get('kmDriven')} KM',),
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                      : const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          }),
    );
  }
}
