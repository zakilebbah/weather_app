import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/utils/utilFunctions.dart';

import '../models/country.dart';

class RemoteData {
  String _restCountriesUrl = "https://restcountries.com/v3.1";
  String _weathermapUrl = "https://api.openweathermap.org/data/2.5/weather";
  String _weathermaKey = "2a63928ffc5d230c155fbafe5fbf779f";
  Future<List<Country>> getAllCountries(String region) async {
    print("getAllCountries");
    String searchType = "independent";
    if (region != "") {
      searchType = "region/$region";
    }
    try {
      final dio = Dio();
      String url =
          "$_restCountriesUrl/$searchType?status=true&fields=capital,latlng,name";
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        // print(response.data);
        // List<Country> countries = [];
        // for (Map json in response.data) {
        //   json['weather'] = await getCountryWeather(
        //       MyFunct.fromListToDoubleList(json['latlng']));
        //   countries.add(Country.fromJson(json));
        // }
        return response.data
            .map<Country>((json) => Country.fromJson(json))
            .toList();
        // return countries;
      } else if (response.statusCode == 404) {
        return [];
      } else {
        throw Exception(response.data);
      }
    } catch (e) {
      if (e is DioError) {
        return [];
      } else {
        throw Exception(e);
      }
    }
  }

  Future<Map> getCountryWeather(List<double> latlng) async {
    // print("SSSSSSSSSSSSSSSs");
    if (latlng.length == 0) {
      return {};
    }
    double lat = latlng[0];
    double long = latlng[1];
    final dio = Dio();
    String url =
        "$_weathermapUrl?lat=$lat&lon=$long&&units=metric&appid=$_weathermaKey";
    // print(url);
    final response = await dio.get(url);
    if (response.statusCode == 200) {
      // print(response.data);
      return response.data;
    } else {
      throw Exception(jsonDecode(response.data));
    }
  }
}

final countriesProvider = Provider<RemoteData>((ref) => RemoteData());
