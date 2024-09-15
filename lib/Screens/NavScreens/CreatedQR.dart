import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:genscan_qr/Controllers/QrCreateController.dart';

import 'package:genscan_qr/Widgets/expanded_button.dart';
import 'package:genscan_qr/Widgets/input_field.dart';
import 'package:genscan_qr/constants.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../Controllers/QrDataController.dart';

class CreateQRScreen extends StatelessWidget {
  CreateQRScreen({super.key});
  QrDataController qrDataController = Get.find<QrDataController>();
  QrCreateController qrCreateController = Get.find<QrCreateController>();

  GlobalKey globalKey = GlobalKey();

  static final foucsNode = FocusNode();

  Widget selectWidget(type value) {
    switch (value) {
      case type.Text:
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              InputFields(
                name: 'Text',
                textEditingController: qrCreateController.qrDataValueController,
              ),
            ],
          ),
        );
      case type.Wifi:
        List<String> wifiSecurityTypes = [
          'Open',
          'WEP',
          'WPA',
        ];
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              InputFields(
                name: 'SSID',
                textEditingController: qrCreateController.qrDataValueController,
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: DropdownButtonFormField(
                  borderRadius: BorderRadius.circular(12),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.grey.shade300, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black87, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  value: qrCreateController.securityType.value,
                  hint: const Text('Select Security Type'),
                  items: wifiSecurityTypes.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    log(newValue.toString());
                    qrCreateController.changeSecurityType(newValue.toString());
                  },
                ),
              ),
              Visibility(
                visible: qrCreateController.securityType.value != 'Open',
                child: InputFields(
                  name: 'Password',
                  textEditingController: qrCreateController.qrCodeController,
                ),
              ),
              CheckboxListTile(
                value: qrCreateController.hideSSID.value,
                onChanged: (value) {
                  qrCreateController.changeHideSSIDStatus(value!);
                },
                title: const Text('Hidden'),
                checkColor: backgroundColor,
                activeColor: Colors.black87,
              ),
            ],
          ),
        );
      case type.Email:
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              InputFields(
                name: 'Email',
                textEditingController: qrCreateController.qrEmailController,
              ),
              InputFields(
                name: 'Subject',
                textEditingController: qrCreateController.qrCodeController,
              ),
              InputFields(
                name: 'Body',
                textEditingController: qrCreateController.qrDataValueController,
                textBox: true,
              ),
            ],
          ),
        );
      case type.Phoneno:
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InputFields(
                      name: 'Code',
                      textEditingController:
                          qrCreateController.qrCodeController,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: InputFields(
                      name: 'Phone Number',
                      textEditingController:
                          qrCreateController.qrDataValueController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case type.Link:
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              InputFields(
                name: 'Link',
                textEditingController: qrCreateController.qrDataValueController,
              ),
            ],
          ),
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:
                GetBuilder<QrCreateController>(builder: (qrCreateController) {
              return SingleChildScrollView(
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.08,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: type.values.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            width: 100,
                            child: ExpandedButton(
                              name: type.values[index].name,
                              onTap: () {
                                qrCreateController
                                    .changeWidget(type.values[index]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${qrCreateController.selectedWidget.name} QR',
                      style: widgetHeading(),
                    ),
                    selectWidget(qrCreateController.selectedWidget),
                    ExpandedButton(
                        name: 'Create',
                        onTap: () {
                          qrCreateController.createQrData(context);
                        })
                    // Card(
                    //   elevation: 0,
                    //   color: Colors.grey.shade200,
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: TextField(
                    //           controller: _qrController,
                    //           focusNode: foucsNode,
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .titleLarge!
                    //               .copyWith(fontSize: 18.0),
                    //           decoration: const InputDecoration(
                    //               hintText: 'Enter Text',
                    //               border: InputBorder.none,
                    //               contentPadding: EdgeInsets.symmetric(
                    //                   horizontal: 12.0, vertical: 12.0)),
                    //         ),
                    //       ),
                    //       Container(
                    //         // width: 15,
                    //         // height: 15,
                    //         margin: const EdgeInsets.only(right: 8),
                    //         child: InkWell(
                    //           onTap: () {
                    //             CreateQRScreen.foucsNode.unfocus();
                    //             showModalBottomSheet(
                    //               elevation: 0,
                    //               backgroundColor:
                    //                   Theme.of(context).scaffoldBackgroundColor,
                    //               context: context,
                    //               builder: (context) {
                    //                 return Column(
                    //                   mainAxisSize: MainAxisSize.min,
                    //                   children: [
                    //                     Padding(
                    //                       padding: const EdgeInsets.symmetric(
                    //                           vertical: 12.0),
                    //                       child: Center(
                    //                         child: Screenshot(
                    //                           controller: _screenshotController,
                    //                           child: Container(
                    //                             width: 220,
                    //                             height: 220,
                    //                             color: Colors.white,
                    //                             child: Center(
                    //                               child: QrImageView(
                    //                                 data: _qrController.text,
                    //                                 size: 200,
                    //                                 version: QrVersions.auto,
                    //                                 gapless: true,
                    //                                 errorStateBuilder: (cxt, err) {
                    //                                   return Container(
                    //                                     child: const Center(
                    //                                       child: Text(
                    //                                         'Uh oh! Something went wrong...',
                    //                                         textAlign:
                    //                                             TextAlign.center,
                    //                                       ),
                    //                                     ),
                    //                                   );
                    //                                 },
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.center,
                    //                       children: [
                    //                         ElevatedButton(
                    //                             onPressed: () async {
                    //                               qrDataController.addQrData(
                    //                                   'QR',
                    //                                   _qrController.text,
                    //                                   type.Text.name,
                    //                                   homepagefilter.Created.name);
                    //                               await _captureAndSaveQRCode(
                    //                                   context);
                    //                             },
                    //                             child: const Column(
                    //                               children: [
                    //                                 Icon(Icons.download_rounded),
                    //                                 Text('Export')
                    //                               ],
                    //                             )),
                    //                         const SizedBox(
                    //                           width: 10,
                    //                         ),
                    //                         ElevatedButton(
                    //                             onPressed: () async {
                    //                               await _shareQRCode();
                    //                             },
                    //                             child: const Column(
                    //                               children: [
                    //                                 Icon(Icons.share_rounded),
                    //                                 Text('Share')
                    //                               ],
                    //                             )),
                    //                       ],
                    //                     ),
                    //                     const SizedBox(
                    //                       height: 10,
                    //                     ),
                    //                   ],
                    //                 );
                    //               },
                    //             );
                    //           },
                    //           child: const Icon(Icons.arrow_forward_ios_rounded),
                    //         ),
                    //       )
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              );
            })),
      ),
    );
  }
}
