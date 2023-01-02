import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:spotbuy/Utils/constants.dart';
import '../provider/Vehicle/vehicle_list_provider.dart';
import 'ChatRoom/chat_screen.dart';
import 'Sell/seller_profile.dart';

class VehicleDetailScreen extends StatefulWidget {
  // DocumentSnapshot docId;
  String docId;
  String vehicleType;
  String itemBy;

  VehicleDetailScreen(
      {required this.docId, required this.vehicleType, required this.itemBy});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  List<dynamic> imageRaw = [];
  List<String> image = [];
  bool isGoogleAd = false;
  List<dynamic> docIDDemo = [];
  List<String> docIDs = [];
  String itemByName = '';

  Future<void> getDocId() async {
    await FirebaseFirestore.instance
        .collection('vehicle_database')
        .where('vehicleType', isEqualTo: widget.vehicleType)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              docIDDemo.add(document.reference.id);
              setState(() {});
              docIDs = docIDDemo.map((e) => e.toString()).toList();
            },
          ),
        );
  }


  String contact = '';


  void getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: widget.itemBy)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach(
            (document) {
              contact = document.get('contact');
              setState(() {});
            },
          ),
        );

  }

  @override
  void initState() {
    super.initState();
    getDocId();
    getData();
    setState(() {});
  }

  share(BuildContext context) async {
    final urlImage = image[0];
    final url = Uri.parse(urlImage);
    final response = await http.get(url);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);
    String message =
        "Hi, I'm using SpotBuy, for buying and selling automobiles and  it's services : https://play.google.com/store/apps/details?id=com.s19mobility.spotbuy";

    final RenderBox box = context.findRenderObject() as RenderBox;

    Share.shareFiles([path],
        text: message,
        subject: "Description",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 0,
        backgroundColor: const Color(0xff2E3C5D),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                'Vehicle Detail',
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: 955,
                child: Column(
                  children: [
                    Expanded(
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('vehicle_database')
                            .doc(widget.docId)
                            .snapshots(),
                        builder: (_, snapshot) {
                          if (snapshot.hasError)
                            return Text('Error = ${snapshot.error}');

                          if (snapshot.hasData) {
                            itemByName = snapshot.data!.get('itemByName');
                            imageRaw = snapshot.data!.get('image');
                            image = imageRaw.map((e) => e.toString()).toList();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //Image Carousel
                                Stack(
                                  children: [
                                    ImageSlideshow(
                                      // autoPlayInterval: 3000,
                                      // isLoop: image.length > 1 ? true : false,
                                      width: double.infinity,
                                      children: image.map((String image) {
                                        return Image.network(
                                          image,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          fit: BoxFit.cover,
                                        );
                                      }).toList(),
                                    ),
                                    Positioned(
                                      right: 5,
                                      top: 5,
                                      child: IconButton(
                                        onPressed: () {
                                          share(context);
                                        },
                                        icon: const Icon(Icons.share),
                                      ),
                                    )
                                  ],
                                ),

                                const Divider(
                                  thickness: 2,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data!.get('title'),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                snapshot.data!.get("brand"),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Chip(
                                            backgroundColor: Colors.cyanAccent,
                                            label: Text(snapshot.data!
                                                .get("yearModel")),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "₹ ${snapshot.data!.get("sellAmount").toInt()}",
                                        style: const TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Overview",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 9),
                                      Card(
                                        elevation: 15,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/petrol_pump_icon.png',
                                                    fit: BoxFit.cover,
                                                    height: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(snapshot.data!
                                                      .get("fuelType")),
                                                  const SizedBox(width: 120),
                                                  Image.asset(
                                                    'assets/icons/range_icon.png',
                                                    fit: BoxFit.cover,
                                                    height: 20,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      "${snapshot.data!.get("kmDriven")} KM"),
                                                ],
                                              ),
                                              const Divider(
                                                thickness: 2,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.person),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        snapshot.data!
                                                            .get("ownerNo"),
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 140),
                                                      const Icon(Icons
                                                          .location_on_outlined),
                                                      const SizedBox(width: 5),
                                                      Column(
                                                        children: [
                                                          SizedBox(
                                                            width: 60,
                                                            child: Text(snapshot.data!
                                                                .get("place"),
                                                              textAlign: TextAlign.justify,),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      isGoogleAd
                                          ? Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                child: Container(
                                                  color: Colors.pink[100],
                                                  width: 250,
                                                  height: 125,
                                                  child: const Center(
                                                    child: Text(
                                                      "Google Ads.",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : SizedBox(),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Description",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Text(
                                        snapshot.data!.get("descriptionText"),
                                        textAlign: TextAlign.justify,
                                      ),
                                      const SizedBox(height: 10),
                                      Card(
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: InkWell(
                                            onTap: ()  {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      SellerProfile(
                                                    itemBy: snapshot.data!
                                                        .get('itemBy'),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                 SizedBox(
                                                  height: 65,
                                                  width: 65,
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.brown,
                                                    child: Text(
                                                      snapshot.data!
                                                          .get("itemByName")[0],
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 32,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 7),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Posted By",
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                      snapshot.data!
                                                          .get("itemByName"),
                                                      style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const Text(
                                                      "See Profile",
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Text(
                                        "Related Ads",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      // Row(
                                      //   children: [
                                      //     RelatedAdsWidgets(
                                      //       1233,
                                      //       "Ola S1 Pro",
                                      //       "https://ic1.maxabout.us/autos/tw_india//O/2021/11/ola-scooter.jpg",
                                      //     ),
                                      //     RelatedAdsWidgets(
                                      //       1234,
                                      //       "Pulser 125",
                                      //       "https://media.zigcdn.com/media/model/2021/Aug/right-side-view-127437109_600x400.jpg",
                                      //     ),
                                      //     RelatedAdsWidgets(
                                      //       1234,
                                      //       "Java 350",
                                      //       "https://media.zigcdn.com/media/model/2021/Apr/lest-side-view-405306884_930x620.jpg",
                                      //     ),
                                      //   ],
                                      // ),
                                      const SizedBox(height: 10),
                                      // Center(
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //                   vertical: 20),
                                      //           child: Container(
                                      //             color: Colors.pink[100],
                                      //             width: 250,
                                      //             height: 125,
                                      //             child: const Center(
                                      //               child: Text(
                                      //                 "Google Ads.",
                                      //                 style: TextStyle(
                                      //                   fontSize: 20,
                                      //                   fontWeight:
                                      //                       FontWeight.bold,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                          ;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: SizedBox(
                        height: 230,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: docIDs.length,
                          itemBuilder: (_, index) {
                            return StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection('vehicle_database')
                                    .doc(docIDs[index])
                                    .snapshots(),
                                builder: (_, snapshot) {
                                  print(
                                      "Snapshot Data of related ads:- $snapshot");
                                  if (snapshot.hasError) {
                                    return Column(
                                      children: [
                                        Text('Error = ${snapshot.error}'),
                                        CircularProgressIndicator(),
                                      ],
                                    );
                                  }

                                  List<dynamic> relatedImage = [];
                                  relatedImage = snapshot.data!.get('image');
                                  if (widget.docId == snapshot.data!.id) {
                                    return SizedBox();
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VehicleDetailScreen(
                                                docId: snapshot.data!.id,
                                                vehicleType: snapshot.data!
                                                    .get('vehicleType'),
                                                itemBy: snapshot.data!
                                                    .get('itemBy'),
                                              ),
                                            ));
                                      },
                                      child: RelatedAdsWidgets(
                                        snapshot.data!.get('sellAmount'),
                                        snapshot.data!.get('title'),
                                        relatedImage[0],
                                      ),
                                    );
                                  }
                                  // return Text(snapshot.data!.get('title'));
                                });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff2E3C5D)),
                  fixedSize: MaterialStateProperty.all(
                    const Size(170, 40),
                  ),
                ),
                icon: Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            toId: widget.itemBy,
                            name: itemByName,
                        mobile: contact,
                          )));
                },
                label: const Text(
                  "Message",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(
                  Icons.call,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xff2E3C5D)),
                  fixedSize: MaterialStateProperty.all(
                    const Size(170, 40),
                  ),
                ),
                onPressed: () async {
                  await FlutterPhoneDirectCaller.callNumber("+91 $contact");
                  final snackBar = SnackBar(
                    content: Text('Calling to $contact'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                label: const Text(
                  "Call",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget RelatedAdsWidgets(price, name, imageURL) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 50),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        elevation: 10,
        child: SizedBox(
          height: 120,
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
                width: 120,
                child: Image.network(
                  imageURL,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "\u{20B9}$price",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      name,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
