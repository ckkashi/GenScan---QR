import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genscan_qr/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class CreateQRScreen extends StatelessWidget {
  CreateQRScreen({super.key});

  GlobalKey globalKey = new GlobalKey();
  static final _qrController = TextEditingController();
  static final foucsNode = FocusNode();

  final _screenshotController = ScreenshotController();

  Future<void> _captureAndSaveQRCode() async {
    Uint8List? uint8list = await _screenshotController.capture();
    if (uint8list != null) {
      final permission = await Permission.storage.request();
      if (permission.isGranted) {
        final result = await ImageGallerySaver.saveImage(uint8list);
        if (result['isSuccess']) {
          log('Image saved successfully');
        } else {
          log('Failed to save image ${result['error']}');
        }
      } else {
        log('Permission to access storage');
        Permission.storage.request();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  createQR,
                  style: pageHeading(),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _qrController,
                          focusNode: foucsNode,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 18.0),
                          decoration: const InputDecoration(
                              hintText: 'Enter Text',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12.0)),
                        ),
                      ),
                      Container(
                        // width: 15,
                        // height: 15,
                        margin: EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () {
                            CreateQRScreen.foucsNode.unfocus();
                            showModalBottomSheet(
                              elevation: 0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              context: context,
                              builder: (context) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Center(
                                        child: Screenshot(
                                          controller: _screenshotController,
                                          child: Container(
                                            width: 220,
                                            height: 220,
                                            color: Colors.white,
                                            child: Center(
                                              child: QrImageView(
                                                data: _qrController.text,
                                                size: 200,
                                                version: QrVersions.auto,
                                                gapless: true,
                                                errorStateBuilder: (cxt, err) {
                                                  return Container(
                                                    child: const Center(
                                                      child: Text(
                                                        'Uh oh! Something went wrong...',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              await _captureAndSaveQRCode();
                                            },
                                            child: const Column(
                                              children: [
                                                Icon(Icons.download_rounded),
                                                Text('Export')
                                              ],
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {},
                                            child: const Column(
                                              children: [
                                                Icon(Icons.share_rounded),
                                                Text('Share')
                                              ],
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            )),
      ),
    );
  }
}
