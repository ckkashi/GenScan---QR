import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:genscan_qr/Models/qrdata.dart';
import 'package:genscan_qr/Screens/NavScreens/DetailQR.dart';
import 'package:genscan_qr/Widgets/qr_scanner_overlay.dart';
import 'package:genscan_qr/constants.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRScreen extends StatelessWidget {
  ScanQRScreen({super.key});

  final MobileScannerController scannerController = MobileScannerController();

  setType(BarcodeType giventype) {
    log(giventype.name);
    switch (giventype) {
      case BarcodeType.wifi:
        return type.Wifi.name;
      case BarcodeType.url:
        return type.Link.name;
      case BarcodeType.email:
        return type.Email.name;
      case BarcodeType.phone:
        return type.Phoneno.name;
      default:
        return type.Text.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
                const Spacer(),
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    children: [
                      MobileScanner(
                        controller: scannerController,
                        onDetect: (capture) {
                          scannerController.stop();
                          final List<Barcode> barcodes = capture.barcodes;
                          log(barcodes[0].rawValue.toString());
                          QrData data = QrData(
                              name:
                                  "QR - ${DateTime.now().microsecondsSinceEpoch}",
                              data: barcodes[0].rawValue.toString(),
                              type: setType(barcodes[0].type),
                              nature: homepagefilter.Scanned.name,
                              timestamp: DateTime.now().toString());
                          log(data.toString());
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return DetailQRScreen(
                                data: data,
                              );
                            },
                          ));
                          scannerController.start();
                        },
                      ),
                      const QRScannerOverlay(overlayColour: Colors.white),
                    ],
                  ),
                ),
                const Spacer(),
                const Text('Place QR in this area'),
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
