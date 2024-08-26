import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:genscan_qr/Screens/NavScreens/DetailQR.dart';
import 'package:genscan_qr/Screens/NavScreens/Profile.dart';
import 'package:genscan_qr/Widgets/qr_scanner_overlay.dart';
import 'package:genscan_qr/constants.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRScreen extends StatelessWidget {
  ScanQRScreen({super.key});

  final MobileScannerController scannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Text(
                      scanQR,
                      style: pageHeading(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Spacer(),
                Container(
                  width: 220,
                  height: 220,
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: scannerController,
                        onDetect: (capture) {
                          scannerController.stop();
                          final List<Barcode> barcodes = capture.barcodes;
                          Map<String, dynamic> data = {
                            'QRValue': barcodes[0].rawValue,
                            'format': barcodes[0].format,
                            'valueType': barcodes[0].type,
                          };
                          log(data.toString());
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return DetailQRScreen(
                                data: data,
                              );
                            },
                          ));
                          // scannerController.start();
                        },
                      ),
                      const QRScannerOverlay(overlayColour: Colors.white),
                    ],
                  ),
                ),
                Spacer(),
                Text('Place QR in this area'),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
