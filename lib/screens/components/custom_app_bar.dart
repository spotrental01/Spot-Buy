import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotbuy/provider/Vehicle/vehicles_categories_provider.dart';
import 'package:spotbuy/provider/Vehicle/vehicle_list_provider.dart';
import 'package:spotbuy/screens/drawer/About.dart';
import 'package:spotbuy/screens/drawer/navigation_drawer_screen.dart';
import 'package:spotbuy/screens/drawer/drawer.dart';
import 'package:spotbuy/screens/profile.dart/profile_page.dart';

import '../../Utils/constants.dart';
import '../../Utils/size_config.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String label = 'Place';
  void changeLabel() async {
    String dummy = await cUserLoc();
    setState(() {
      label = dummy;
    });
  }

  @override
  Widget build(BuildContext context) {
    changeLabel();
    return Row(
      children: [
        FloatingActionButton(
          backgroundColor: Colors.white,
          splashColor: sbPrimaryColor,
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          child: Icon(
            Icons.menu,
            size: getProportionateScreenWidth(25),
          ),
        ),

        const Spacer(),
        InkWell(
          onTap: () {
            Provider.of<CategoriesProvider>(context, listen: false);
          },
          child: Chip(
            elevation: 5,
            backgroundColor: Colors.grey[200],
            labelStyle: TextStyle(
              fontSize: getProportionateScreenWidth(20),
              fontWeight: FontWeight.bold,
            ),
            label: Container(
              margin: EdgeInsets.all(getProportionateScreenWidth(5)),
              child: Text(
                label,
              ),
            ),
          ),
        )
      ],
    );
  }
}
