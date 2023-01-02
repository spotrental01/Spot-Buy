import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotbuy/Utils/constants.dart';
import 'package:spotbuy/provider/Vehicle/vehicle_list_provider.dart';

import '../../models/Core_Model/vehicle_data_model.dart';
import 'EditVehicle.dart';

class AdsScreen extends StatefulWidget {
  const AdsScreen({Key? key}) : super(key: key);

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  void fetchData(List data, BuildContext context) {
    Provider.of<VehicleProvider>(context).fetchAllVehicleData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 0,
        backgroundColor: Color(0xff2E3C5D),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Ads',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('vehicle_database')
          .where('itemBy', isEqualTo:cUser().uid )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Container(
                  child: const Text(
                    'No Ads Avaliable',
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10.0),
                ),
              );
            }
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  child: const Text(
                    'No Ads Avaliable',
                    style: TextStyle(
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black38,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10.0),
                ),
              );
            }
            var data = snapshot.data!.docs;
            String truncate(String text, {length: 7, omission: '...'}) {
              if (length >= text.length) {
                return text;
              }
              return text.replaceRange(length, text.length, omission);
            }

            List<VehicleModel> vehicleList = [];
            for (var ele in data) {
              var temp = ele.id;
              var element = ele.data()! as Map<String, dynamic>;
              if (element['itemBy'] == cUser().uid) {
                vehicleList.add(VehicleModel(
                  vehicleId: element['vehicleId'],
                  vehicleType: element['vehicleType'],
                  image: element['image'],
                  title: element['title'],
                  yearModel: element['yearModel'],
                  ownerNo: element['ownerNo'],
                  kmDriven: element['kmDriven'],
                  fuelType: element['fuelType'],
                  descriptionText: element['descriptionText'],
                  sellAmount: element['sellAmount'],
                  itemBy: element['itemBy'],
                  dbId: temp,
                  vehicle: element['vehicle'],
                  postNo: element['postNo'],
                  brand: element['brand'],
                  itemByName: element['itemByName'],
                ));
              }
            }
            // fetchData(data, context);

            return vehicleList.isEmpty?Center(
              child: Container(
                child: const Text(
                  'No Ads Avaliable',
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black38,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(10.0),
              ),
            ):ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: vehicleList.length,
                itemBuilder: (context, index) {
                  return snapshot.data!.docs[index].get('status') == 'DELETED'
                      ? SizedBox()
                      : Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 5,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditVehicle(
                                          currentVehicle: vehicleList[index]),
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: Image.network(
                                                snapshot.data!.docs[index]
                                                    .get('image')[0],
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${snapshot.data!.docs[index].get('brand')} ${snapshot.data!.docs[index].get('vehicle')}",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Rs ${snapshot.data!.docs[index].get('sellAmount')}",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 160,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "${snapshot.data!.docs[index].get('yearModel')} |",
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            truncate(
                                                              ' ${snapshot.data!.docs[index].get('kmDriven')}KM',
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Chip(
                                                    side: BorderSide(
                                                        color: snapshot.data!.docs[index].get('status') == 'APPROVED' ? Colors.green
                                                            : snapshot.data!.docs[index].get('status') == 'REJECT' ? Colors.red
                                                            : Colors.yellow),
                                                    backgroundColor: snapshot.data!.docs[index].get('status') == 'APPROVED'? Colors.green[100]
                                                            : snapshot.data!.docs[index].get('status') == 'REJECT'
                                                            ? Colors.red[100]
                                                            : Colors.yellow[100],
                                                    label: Row(
                                                      children: [
                                                        Icon(
                                                          snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          'status') ==
                                                                  'APPROVED'
                                                              ? Icons.done
                                                              : snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .get(
                                                                              'status') ==
                                                                      'REJECT'
                                                                  ? Icons.close
                                                                  : Icons
                                                                      .access_time,
                                                          color: snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          'status') ==
                                                                  'APPROVED'
                                                              ? Colors.green
                                                              : snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .get(
                                                                              'status') ==
                                                                      'REJECT'
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .yellow,
                                                        ),
                                                        SizedBox(width: 2),
                                                        Text(
                                                          snapshot
                                                              .data!.docs[index]
                                                              .get('status'),
                                                          style: TextStyle(
                                                            color: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .get(
                                                                            'status') ==
                                                                    'APPROVED'
                                                                ? Colors.green
                                                                : snapshot
                                                                            .data!
                                                                            .docs[
                                                                                index]
                                                                            .get(
                                                                                'status') ==
                                                                        'REJECT'
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .yellow,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  showDialog(context: context, builder: (context) {
                                                    return AlertDialog(
                                                      title: const Text("Are your sure want to delete?"),
                                                      icon: const Icon(Icons.delete,color: Colors.red),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("Cancle"),
                                                        ),TextButton(
                                                          onPressed: () {
                                                            deletePost(vehicleList[index]);
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: const Text("OK"),
                                                        )
                                                      ],
                                                    );
                                                  },);
                                                },
                                                icon: Icon(
                                                  Icons.delete_outline_outlined,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                });
          }),
    );
  }

  Future<void> deletePost(VehicleModel vehicleModel) async {
    Map<String, dynamic> obj = {
      'status': "DELETED",
    };
    await FirebaseFirestore.instance.collection('vehicle_database').doc(vehicleModel.dbId).update(obj);
  }
}
