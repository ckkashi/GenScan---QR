import 'package:flutter/material.dart';
import 'package:genscan_qr/Screens/NavScreens/ScanQR.dart';
import 'package:genscan_qr/constants.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DetailQRScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const DetailQRScreen({super.key, required this.data});

  String newLine(String value) {
    return value.replaceAll(';', '\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanQRScreen(),
                ));
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    details,
                    style: pageHeading(),
                  ),
                ],
              ),
              Spacer(),
              Text(
                newLine(data['QRValue']),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 16,
                    ),
              ),
              Spacer(),
              Center(
                child: QrImageView(
                  data: data['QRValue'],
                  size: 200,
                  version: QrVersions.auto,
                  gapless: true,
                  errorStateBuilder: (cxt, err) {
                    return Container(
                      child: const Center(
                        child: Text(
                          'Uh oh! Something went wrong...',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
