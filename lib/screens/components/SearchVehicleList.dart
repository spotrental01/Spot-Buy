import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotbuy/provider/Vehicle/vehicles_categories_provider.dart';

import '../../models/Core_Model/categories_model.dart';
import '../../provider/Vehicle/vehicle_list_provider.dart';
import '../vehicle_detail_screen.dart';

class SearchVehicleList extends StatefulWidget {
  final String search;

  const SearchVehicleList({Key? key, required this.search}) : super(key: key);

  @override
  _SearchVehicleListState createState() => _SearchVehicleListState(search);
}

class _SearchVehicleListState extends State {
  final String search;

  _SearchVehicleListState(this.search);

  late CategoriesModel selectedCategory;

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
          stream: FirebaseFirestore.instance
              .collection('vehicle_database')
              .where("status", isEqualTo: 'APPROVED')
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

            String truncate(String text, {length: 12, omission: '...'}) {
              if (length >= text.length) {
                return text;
              }
              return text.replaceRange(length, text.length, omission);
            }

            var data = snapshot.data!.docs as List;

            fetchData(data, context);
            selectedCategory =
                Provider.of<CategoriesProvider>(context).getFirstCategory();

            final vehicleList = Provider.of<VehicleProvider>(context)
                .getVehicleById(selectedCategory.id);
            return vehicleList.isEmpty
                ? const Center(child: Text("No Vehicle Found!"))
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
                                        builder: (context) =>
                                            VehicleDetailScreen(
                                          docId: snapshot.data!.docs[index].id,
                                          vehicleType: snapshot
                                              .data!.docs[index]
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Rs ${snapshot.data!.docs[index].get('sellAmount')}",
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                          truncate(
                                                            ' ${snapshot.data!.docs[index].get('kmDriven')}KM',
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              const TextStyle(
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
