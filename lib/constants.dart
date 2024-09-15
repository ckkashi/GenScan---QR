import 'package:flutter/material.dart';

//strings

const String appName = 'GenScan QR';
const String scanQR = 'Scan QR';
const String createQR = 'Create QR';
const String details = 'Details';
const String home = 'Home';

//colors

const Color backgroundColor = Color(0xFFFFFFFF);

//textstyles

TextStyle widgetHeading() => const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 24,
    );

TextStyle pageHeading() => const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 30,
    );

//enums

enum type { Text, Wifi, Link, Phoneno, Email }

enum homepagefilter {
  All,
  Created,
  Scanned,
}
