import 'package:flutter/cupertino.dart';
import 'package:genscan_qr/Controllers/QrCreateController.dart';
import 'package:genscan_qr/Controllers/QrDataController.dart';
import 'package:genscan_qr/Screens/NavScreens/CreatedQR.dart';
import 'package:genscan_qr/Screens/NavScreens/Home.dart';
import 'package:genscan_qr/Screens/NavScreens/ScanQR.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainHome extends StatelessWidget {
  MainHome({super.key});

  final QrDataController qrController = Get.put(QrDataController());
  final QrCreateController qrCreateController = Get.put(QrCreateController());

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [HomeScreen(), CreateQRScreen(), ScanQRScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.home),
        title: ("Home"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.qrcode),
        title: ("Create"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(CupertinoIcons.qrcode_viewfinder),
        title: ("Scan"),
        activeColorPrimary: CupertinoColors.black,
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      items: _navBarsItems(),
      screens: _buildScreens(),
      navBarStyle: NavBarStyle.style9,
      handleAndroidBackButtonPress: true,
    );
  }
}
