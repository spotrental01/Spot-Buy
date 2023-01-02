import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spotbuy/Utils/constants.dart';

class edit_Info extends StatefulWidget {
  DocumentSnapshot docid;

  edit_Info({required this.docid});

  @override
  _edit_InfoState createState() => _edit_InfoState();
}

class _edit_InfoState extends State<edit_Info> {
  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController gender = TextEditingController();

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.docid.get('name'));
    contact = TextEditingController(text: widget.docid.get('contact'));
    email = TextEditingController(text: widget.docid.get('email'));
    gender = TextEditingController(text: widget.docid.get('gender'));
    address = TextEditingController(text: widget.docid.get('address'));
  }

  final _formKey = GlobalKey<FormState>();

  //Image Backend
  File? image1;

  Future getPhoto() async {
    final image1 = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image1 == null) return;

    final imageTemporary = File(image1.path);
    setState(() {
      this.image1 = imageTemporary;
    });
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
                'Update Profile',
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: getPhoto,
                child: CircleAvatar(
                  backgroundColor: const Color(0xff2E3C5D),
                  radius: 40.0,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 38,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: image1 == null
                                ? Image.asset("assets/images/upload.jpg").image
                                : Image.file(image1!).image,
                          )),
                    ),
                  ),
                ),
              ),
              image1 == null ?
              Text(
                "Upload profile picture here",
                style: TextStyle(
                  fontSize: 18,
                ),
              ): SizedBox(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter You\'r Name';
                    }
                    return null;
                  },
                  controller: name,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.perm_identity),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: 'Full Name',
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Your Contact No.';
                    }
                    return null;
                  },
                  controller: contact,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: 'Contact',
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Email';
                    }
                    return null;
                  },
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: 'Email',
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Your Gender';
                    }
                    return null;
                  },
                  controller: gender,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.male_sharp),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: 'Gender',
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Address';
                    }
                    return null;
                  },
                  controller: address,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_pin),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    labelText: 'Address',
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text("Cancel"),
                  ),
                  SizedBox(width: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      widget.docid.reference.update({
                        'name': name.text,
                        'contact': contact.text==null || contact.text =="" ?cUser().phoneNumber:contact.text,
                        'email': email.text,
                        'gender': gender.text,
                        'address': address.text,
                      }).whenComplete(() {
                        Navigator.of(context).pop();
                      });
                    },
                    icon: const Icon(Icons.cloud_done),
                    label: const Text("Update"),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
