import 'package:flutter/cupertino.dart';
import 'package:genscan_qr/Screens/NavScreens/CreatedQR.dart';
import 'package:genscan_qr/Screens/NavScreens/ScanQR.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainHome extends StatelessWidget {
  MainHome({super.key});

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [CreateQRScreen(), ScanQRScreen()];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
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
    return PersistentTabView(context,
        controller: _controller,
        items: _navBarsItems(),
        screens: _buildScreens());
  }
}
