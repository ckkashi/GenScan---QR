class QrData {
  int? id;
  String name;
  String data;
  String type;
  String nature;
  String timestamp;

  QrData(
      {this.id,
      required this.name,
      required this.data,
      required this.type,
      required this.nature,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'data': data,
      'type': type,
      'nature': nature,
      'timestamp': timestamp
    };
  }

  factory QrData.fromMap(Map<String, dynamic> map) {
    return QrData(
        id: map['id'],
        name: map['name'],
        data: map['data'],
        type: map['type'],
        nature: map['nature'],
        timestamp: map['timestamp']);
  }
}
