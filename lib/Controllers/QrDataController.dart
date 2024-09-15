import 'dart:developer';

import 'package:get/get.dart';
import '../Services/dbhelper.dart';
import '../Models/qrdata.dart';

class QrDataController extends GetxController {
  var qrDataList = <QrData>[].obs;
  DatabaseHelper databaseHelper = DatabaseHelper();
  var homepageSelector = 'All'.obs;
  changeSelector(String value) {
    homepageSelector.value = value;
    fetchQrData();
  }

  @override
  void onInit() {
    super.onInit();
    fetchQrData();
  }

  void fetchQrData() async {
    qrDataList.value = await databaseHelper.getAllQrData();
    update();
  }

  Future<int> addQrData(
      String name, String data, String type, String nature) async {
    QrData qrData = QrData(
        name: name,
        data: data,
        type: type,
        nature: nature,
        timestamp: DateTime.now().toString());
    int res = await databaseHelper.insertQrData(qrData);
    if (res > 0) {
      fetchQrData();
      return 1;
    } else {
      return 0;
    }
  }
}
