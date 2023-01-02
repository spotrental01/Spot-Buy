import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotbuy/provider/UI/bottom_tab_navigation_provider.dart';
import 'package:spotbuy/Utils/size_config.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          for (final tabItem in TabNavigationItemsData.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16,4,16,16),
        child: BottomNavyBar(
          backgroundColor: const Color(0xff2E3C5D),
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 0,
          curve: Curves.easeIn,
          iconSize: 30,
          onItemSelected: (value) => setState(() => _currentIndex = value),
          items: [
            for (var item in TabNavigationItemsData.items)
              BottomNavyBarItem(
                icon: item.icon,
                title: Text(
                  item.title,
                  style: TextStyle(color: Colors.white),
                ),
                activeColor: Colors.white70,
                textAlign: TextAlign.center,
              )
          ],
        ),
      ),

    );
  }
}
