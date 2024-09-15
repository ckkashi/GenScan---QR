import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:genscan_qr/Controllers/QrDataController.dart';
import 'package:genscan_qr/Models/qrdata.dart';
import 'package:genscan_qr/Widgets/expanded_button.dart';
import 'package:genscan_qr/Widgets/qr_data_card.dart';
import 'package:genscan_qr/constants.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  QrDataController qrController = Get.find<QrDataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              Text(
                appName,
                style: pageHeading(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.08,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    homepagefilter.values.length,
                    (index) {
                      return Expanded(
                        // width: 100,
                        child: ExpandedButton(
                          name: homepagefilter.values[index].name,
                          onTap: () {
                            qrController.changeSelector(
                                homepagefilter.values[index].name);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: qrController.qrDataList.length,
                    itemBuilder: (context, index) {
                      log((qrController.homepageSelector.value.toLowerCase() ==
                              qrController.qrDataList[index].nature)
                          .toString());
                      if (qrController.homepageSelector.value ==
                          homepagefilter.values[0].name) {
                        return DataCard(
                          data: qrController.qrDataList[index],
                        );
                      } else if (qrController.homepageSelector.value
                              .toLowerCase() ==
                          qrController.qrDataList[index].nature.toLowerCase()) {
                        return DataCard(
                          data: qrController.qrDataList[index],
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
