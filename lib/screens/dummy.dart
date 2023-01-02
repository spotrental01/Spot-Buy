import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class addEvents extends StatelessWidget {
  TextEditingController name = TextEditingController();
  TextEditingController stateId = TextEditingController();

  CollectionReference ref = FirebaseFirestore.instance.collection('City');

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Events"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter title of event';
                      }
                      return null;
                    },
                    controller: name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'name',
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 7, 15, 7),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter Description';
                      }
                      return null;
                    },
                    controller: stateId,
                    maxLength: 90,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.description_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'state ID',
                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.add({
                        'Name': name.text,
                        'StateId': stateId.text,
                      }).whenComplete(() {
                        Navigator.of(context).pop();
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text("Add City"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // Create a Form widget.
// class MyCustomForm extends StatefulWidget {
//   @override
//   MyCustomFormState createState() {
//     return MyCustomFormState();
//   }
// }
//
// // Create a corresponding State class, which holds data related to the form.
// class MyCustomFormState extends State<MyCustomForm> {
//   // Create a global key that uniquely identifies the Form widget
//   // and allows validation of the form.
//   final _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//     // Build a Form widget using the _formKey created above.
//     return Form(
//       key: _formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           TextFormField(
//             decoration: const InputDecoration(
//               icon: Icon(Icons.person),
//               hintText: 'Enter your full name',
//               labelText: 'Name',
//             ),
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Please enter some text';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             decoration: const InputDecoration(
//               icon: Icon(Icons.phone),
//               hintText: 'Enter a phone number',
//               labelText: 'Phone',
//             ),
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Please enter valid phone number';
//               }
//               return null;
//             },
//           ),
//           TextFormField(
//             decoration: const InputDecoration(
//               icon: Icon(Icons.calendar_today),
//               hintText: 'Enter your date of birth',
//               labelText: 'Dob',
//             ),
//             validator: (value) {
//               if (value!.isEmpty) {
//                 return 'Please enter valid date';
//               }
//               return null;
//             },
//           ),
//           Container(
//               padding: const EdgeInsets.only(left: 150.0, top: 40.0),
//               child: ElevatedButton(
//                 child: const Text('Submit'),
//                 onPressed: () {
//                   // It returns true if the form is valid, otherwise returns false
//                   if (_formKey.currentState!.validate()) {
//                     // If the form is valid, display a Snackbar.
//                     // Scaffold.of(context).showSnackBar(
//                     //   const SnackBar(
//                     //     content: Text('Data is in processing.'),
//                     //   ),
//                     // );
//                   }
//                 },
//               )),
//         ],
//       ),
//     );
//   }
// }
