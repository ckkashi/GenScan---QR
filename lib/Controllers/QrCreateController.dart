import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genscan_qr/Controllers/QrDataController.dart';
import 'package:genscan_qr/Models/qrdata.dart';
import 'package:genscan_qr/Screens/NavScreens/DetailQR.dart';
import 'package:genscan_qr/constants.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QrCreateController extends GetxController {
  QrDataController qrDataController = Get.find<QrDataController>();
  final qrNameController = TextEditingController();
  final qrDataValueController = TextEditingController();
  final qrCodeController = TextEditingController();
  final qrEmailController = TextEditingController();

  final screenshotController = ScreenshotController();

  final securityType = 'Open'.obs;
  changeSecurityType(String type) {
    securityType.value = type;
    update();
  }

  final hideSSID = false.obs;
  changeHideSSIDStatus(bool value) {
    hideSSID.value = value;
    update();
  }

  type selectedWidget = type.Text;
  changeWidget(type widget) {
    selectedWidget = widget;
    clearTextEditingController();
    update();
  }

  clearTextEditingController() {
    qrNameController.clear();
    qrDataValueController.clear();
    qrCodeController.clear();
    qrEmailController.clear();
  }

  showMessage(BuildContext context, String msg, bool error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.red : Colors.black87,
    ));
  }

  Future<void> saveQRCode(QrData data, BuildContext context) async {
    int res = await qrDataController.addQrData(
        data.name, data.data, data.type, data.nature);
    if (res == 1) {
      showMessage(context, "QR Code saved successfully", false);
    } else {
      showMessage(context, "QR Code already exists", true);
    }
  }

  Future<void> shareQRCode(BuildContext context) async {
    showMessage(context, 'Please wait for a while', false);
    Uint8List? uint8list = await screenshotController.capture();
    if (uint8list != null) {
      final tempDir = await getTemporaryDirectory();
      File file = await File(
              '${tempDir.path}/${DateTime.now().microsecondsSinceEpoch}qr.png')
          .create();
      await file.writeAsBytes(uint8list).then((value) {
        Share.shareXFiles([XFile(value.path)], text: qrNameController.text);
      });
    }
  }

  Future<dynamic> captureAndSaveQRCode(BuildContext context) async {
    Uint8List? uint8list = await screenshotController.capture();
    if (uint8list != null) {
      final permission = await Permission.storage.request();
      if (permission.isGranted) {
        final result = await ImageGallerySaver.saveImage(uint8list);

        if (result['isSuccess']) {
          log('Image saved successfully');
          // Navigator.pop(context);
          // ignore: use_build_context_synchronously
          showMessage(context, 'QR Code saved to gallery', false);
          return result['filePath'];
        } else {
          log('Failed to save image ${result['error']}');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Failed to save image ${result['error']}')));
        }
      } else {
        log('Permission to access storage');
        Permission.storage.request();
      }
    }
  }

  createQrData(BuildContext context) async {
    String dataValue = '';
    switch (selectedWidget) {
      case type.Text:
        if (qrDataValueController.text.isNotEmpty) {
          dataValue = qrDataValueController.text;
        } else {
          showMessage(context, 'Fill all fields', true);
        }
        break;
      case type.Email:
        if (qrEmailController.text.isNotEmpty &&
            qrCodeController.text.isNotEmpty &&
            qrDataValueController.text.isNotEmpty) {
          dataValue =
              "MATMSG:TO:${qrEmailController.text};SUB:${qrCodeController.text};BODY:${qrDataValueController.text};;";
        } else {
          showMessage(context, 'Fill all fields', true);
        }
        break;
      case type.Link:
        if (qrDataValueController.text.isNotEmpty) {
          dataValue = qrDataValueController.text;
        } else {
          showMessage(context, 'Fill all fields', true);
        }
        break;
      case type.Phoneno:
        if (qrDataValueController.text.isNotEmpty &&
            qrCodeController.text.isNotEmpty) {
          dataValue =
              " ${qrCodeController.text} ${qrDataValueController.text} ";
        } else {
          showMessage(context, 'Fill all fields', true);
        }
        break;
      case type.Wifi:
        if (qrDataValueController.text.isNotEmpty) {
          if (securityType.value != 'Open' &&
              qrCodeController.text.isNotEmpty) {
            dataValue =
                "WIFI:T:${securityType.value};S:${qrDataValueController.text};P:${qrCodeController.text};H:${hideSSID.value};;";
          } else if (securityType.value == 'Open') {
            dataValue =
                "WIFI:T:${securityType.value};S:${qrDataValueController.text};P:;H:${hideSSID.value};;";
          } else {
            showMessage(context, 'Fill all fields', true);
          }
        }
        break;
    }
    if (dataValue.isNotEmpty) {
      log(dataValue);
      QrData data = QrData(
          name: "QR - ${DateTime.now().microsecondsSinceEpoch}",
          data: dataValue,
          type: selectedWidget.name,
          nature: homepagefilter.Created.name,
          timestamp: DateTime.now().toString());
      // await _saveQRCode(data);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailQRScreen(data: data),
          ));
    } else {
      showMessage(context, 'Fill all fields', true);
    }
  }
}
