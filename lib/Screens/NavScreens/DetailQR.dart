import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genscan_qr/Controllers/QrCreateController.dart';
import 'package:genscan_qr/Models/qrdata.dart';
import 'package:genscan_qr/Screens/NavScreens/ScanQR.dart';
import 'package:genscan_qr/Widgets/expanded_button.dart';
import 'package:genscan_qr/constants.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class DetailQRScreen extends StatelessWidget {
  final QrData data;
  DetailQRScreen({super.key, required this.data});

  QrCreateController qrCreateController = Get.find<QrCreateController>();

  String newLine(String value) {
    return value.replaceAll(';', '\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor.withOpacity(0.7),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  )),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 8.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.arrow_back_ios_new_rounded),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Screenshot(
                        controller: qrCreateController.screenshotController,
                        child: Container(
                          color: backgroundColor,
                          padding: const EdgeInsets.all(8),
                          child: QrImageView(
                            data: data.data,
                            size: 150,
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
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      details,
                      style: pageHeading(),
                    ),
                    Card(
                      elevation: 5,
                      color: backgroundColor,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                newLine('Data: '),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Expanded(
                                child: Text(
                                  newLine(data.data.toString()),
                                  overflow: TextOverflow.clip,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                        fontSize: 16,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: InkWell(
                                    onTap: () async {
                                      await Clipboard.setData(
                                              ClipboardData(text: data.data))
                                          .then((value) => ScaffoldMessenger.of(
                                                  context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Copied to Clipboard'))));
                                    },
                                    child: Icon(Icons.copy)),
                              ),
                            ]),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color: backgroundColor,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                newLine('Type: '),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                newLine(data.type.toString()),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ]),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color: backgroundColor,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                newLine('Nature: '),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              Text(
                                newLine(data.nature.toString()),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                      fontSize: 16,
                                    ),
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 130,
                      child: Column(
                        children: [
                          Expanded(
                              child: ExpandedButton(
                                  name: 'Save',
                                  onTap: () async {
                                    await qrCreateController.saveQRCode(
                                        data, context);
                                  })),
                          Expanded(
                              child: ExpandedButton(
                                  name: 'Export',
                                  onTap: () async {
                                    await qrCreateController
                                        .captureAndSaveQRCode(context);
                                  })),
                          Expanded(
                              child: ExpandedButton(
                                  name: 'Share',
                                  onTap: () async {
                                    await qrCreateController
                                        .shareQRCode(context);
                                  })),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
