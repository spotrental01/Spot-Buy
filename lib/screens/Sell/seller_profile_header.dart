import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class SellerProfileHeader extends StatefulWidget {
  String itemBy;
  String userDocID;

  SellerProfileHeader({required this.itemBy, required this.userDocID});

  @override
  State<SellerProfileHeader> createState() => _SellerProfileHeaderState();
}

class _SellerProfileHeaderState extends State<SellerProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userDocID)
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: ListTile(
                  leading: SizedBox(
                    height: 50,
                    width: 50,
                    child: CircleAvatar(
                      backgroundColor: Colors.brown,
                      child: Text(
                        snapshot.data!.get('name')[0],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    snapshot.data!.get('name'),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // subtitle: Text(
                  //   snapshot.data!.get('maxSellCount').toString(),
                  //   style: TextStyle(
                  //     fontSize: 17,
                  //     color: Colors.black,
                  //   ),
                  // ),
                ),
              ),
              const Divider(
                thickness: 3,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     Column(
              //       children: const [
              //         CircleAvatar(
              //           backgroundColor: Colors.cyanAccent,
              //           child: Text(
              //             "12",
              //             style: TextStyle(
              //               color: Colors.black,
              //             ),
              //           ),
              //         ),
              //         Text(
              //           "Post",
              //           style: TextStyle(
              //             fontSize: 17,
              //           ),
              //         )
              //       ],
              //     ),
              //     Column(
              //       children: const [
              //         CircleAvatar(
              //           backgroundColor: Colors.cyanAccent,
              //           child: Text(
              //             "434",
              //             style: TextStyle(
              //               color: Colors.black,
              //             ),
              //           ),
              //         ),
              //         Text(
              //           "Followers",
              //           style: TextStyle(
              //             fontSize: 17,
              //           ),
              //         )
              //       ],
              //     ),
              //     Column(
              //       children: const [
              //         CircleAvatar(
              //           backgroundColor: Colors.cyanAccent,
              //           child: Text(
              //             "500",
              //             style: TextStyle(
              //               color: Colors.black,
              //             ),
              //           ),
              //         ),
              //         Text(
              //           "Following",
              //           style: TextStyle(
              //             fontSize: 17,
              //           ),
              //         )
              //       ],
              //     ),
              //   ],
              // ),
              // SizedBox(
              //   width: 120,
              //   child: ElevatedButton(
              //     onPressed: () {},
              //
              //     child: const Text("Follow"),
              //   ),
              // ),
              // SizedBox(height: 20),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ElevatedButton.icon(icon: Icon(Icons.call),
              //       onPressed: () async {
              //         var number = '${snapshot.data!.get('contact')}'; //set the number here
              //
              //        // await FlutterPhoneDirectCaller.callNumber(number);
              //         final snackBar = SnackBar(
              //           content: Text('Calling to ${number}'),
              //         );
              //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
              //       },
              //       label: const Text("Call"),
              //     ),
              //     ElevatedButton.icon(
              //       icon: Icon(Icons.message_outlined),
              //       onPressed: () {},
              //       label: const Text("Message"),
              //     ),
              //   ],
              // ),
            ],
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

}
