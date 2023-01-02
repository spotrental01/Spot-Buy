import 'package:flutter/material.dart';
import 'package:spotbuy/models/UI_Model/tabnavigation_model.dart';
import 'package:spotbuy/screens/Ads/ads_screen.dart';
import 'package:spotbuy/screens/home_screen.dart';

import '../../screens/ChatRoom/message.dart';
import '../../screens/Sell/MySellingScreen.dart';
import '../../screens/Sell/sellScreen.dart';

class TabNavigationItemsData {
  static List<TabNavigationItem> get items => [
        TabNavigationItem(
          page: const HomeScreen(),
          icon: const Icon(Icons.store_rounded),
          title: "Home",
        ),
        TabNavigationItem(
          page: const MessageScreen(),
          icon: const Icon(Icons.message),
          title: "Messages",
        ),
        TabNavigationItem(
          page: const AdsScreen(),
          icon: const Icon(Icons.widgets),
          title: "Ads",
        ),
        // TabNavigationItem(
        //   page: const MySellingScreen(),
        //   icon: const Icon(Icons.sell),
        //   title: 'Post',
        // ),
        TabNavigationItem(
          page: const MySellingScreen(),
          icon: const Icon(Icons.sell),
          title: 'Post',
        ),
      ];
}
