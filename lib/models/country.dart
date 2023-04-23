import '../utils/utilFunctions.dart';

class Country {
  String NAME;
  String CAPITAL;
  List<double> LATLNG;
  Map WEATHER;
  Country(
      {required this.NAME,
      required this.CAPITAL,
      required this.LATLNG,
      required this.WEATHER});

  factory Country.fromJson(Map json) {
    return Country(
        NAME: json['name']['common'],
        CAPITAL: json['capital'].length > 0
            ? json['capital'][0]
            : json['name']['common'],
        LATLNG: MyFunct.fromListToDoubleList(json['latlng']),
        WEATHER: json['weather'] ?? {});
  }
}
