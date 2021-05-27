import 'package:flutter/foundation.dart';

class Trip {
  String city;
  List<String> activities;
  DateTime? date;
  Trip({
    required this.city,
    required this.activities,
    this.date,
  });
}
