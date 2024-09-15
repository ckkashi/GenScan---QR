import 'package:flutter/material.dart';
import 'package:genscan_qr/Models/qrdata.dart';
import 'package:genscan_qr/Screens/NavScreens/DetailQR.dart';
import 'package:genscan_qr/constants.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DataCard extends StatelessWidget {
  const DataCard({
    super.key,
    required this.data,
  });

  final QrData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: ListTile(
        onTap: () {
          //functionality
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return DetailQRScreen(
                data: data,
              );
            },
          ));
        },
        title: Text(data.name),
        subtitle: Text('${data.nature} - ${data.type}'),
        trailing: QrImageView(
          data: data.data,
          size: 50.0,
        ),
      ),
    );
  }
}
