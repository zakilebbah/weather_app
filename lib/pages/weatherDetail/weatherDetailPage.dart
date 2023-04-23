import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:weather_app/utils/remoteData.dart';

import '../../models/country.dart';

final indexProvider = StateProvider<int>(
  (ref) => -1,
);
final weatherDataProvider =
    FutureProvider.autoDispose.family<Map, List<Country>>((ref, countries) {
  final indexState = ref.watch(indexProvider);
  int index00;
  if (indexState == -1) {
    index00 = 0;
  } else if (indexState >= countries.length) {
    index00 = countries.length - 1;
  } else {
    index00 = indexState;
  }
  return ref
      .watch(countriesProvider)
      .getCountryWeather(countries[index00].LATLNG);
});

// I added the possibility to swipe left and right, and I kept the same order from the capitals list

class WeatherDetailPage extends ConsumerWidget {
  final Map<String, List<Country>> countries;
  WeatherDetailPage({super.key, required this.countries});
  int initIndex = -1;
  final RemoteData _remoteData = RemoteData();

  void getCurrentIndex(WidgetRef ref) {
    if (initIndex == -1) {
      int index00 = countries['ALL']!
          .indexWhere((c) => c.CAPITAL == countries['CURRENT']![0].CAPITAL);
      // print(index00);
      if (index00 == -1) {
        ref.read(indexProvider.notifier).state = 0;
        initIndex = 0;
      } else {
        ref.read(indexProvider.notifier).state = index00;
        initIndex = index00;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCurrentIndex(ref);
    });

    final _data = ref.watch(weatherDataProvider(countries['ALL']!));
    return WillPopScope(
      onWillPop: () {
        ref.read(indexProvider.notifier).state = -1;
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text("Slider view"),
          backgroundColor: Colors.blue.shade900,
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.blue.shade900,
        ),
        // Go to next or previous country by swiping left or right
        body: GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) {
            if (dragEndDetails.primaryVelocity! < 0 &&
                ref.read(indexProvider.notifier).state + 1 <
                    countries["ALL"]!.length) {
              ref.read(indexProvider.notifier).state++;
            } else if (dragEndDetails.primaryVelocity! > 0 &&
                ref.read(indexProvider.notifier).state - 1 >= 0) {
              ref.read(indexProvider.notifier).state--;
            }
          },
          child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(30.0),
              color: Colors.blue.shade900,
              child: _data.when(
                  data: (data) {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: const Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: Text(
                                    countries['ALL']![ref
                                            .read(indexProvider.notifier)
                                            .state]
                                        .CAPITAL,
                                    style: const TextStyle(
                                      fontSize: 26,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                  )),
                            ],
                          ),
                          Image.network(
                            "https://openweathermap.org/img/wn/" +
                                data['weather'][0]['icon'] +
                                "@2x.png",
                            width: 123,
                            height: 123,
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 1),
                            child: Text(
                              (data['weather'][0]['description']).toString(),
                              style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 100),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Text(
                                  (data['main']['temp'].round()).toString(),
                                  style: const TextStyle(
                                    fontSize: 42,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                                const Positioned(
                                    top: -8,
                                    right: -30,
                                    child: Text(
                                      '\u00b0 ',
                                      style: TextStyle(
                                        fontSize: 50,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )),
                                const Positioned(
                                    top: -3,
                                    right: -27,
                                    child: Text(
                                      'C',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              data.containsKey('rain')
                                  ? Container(
                                      margin: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.cloudy_snowing,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                          Text(
                                            " " + data['rain']['1h'].toString(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              Container(
                                margin: EdgeInsets.all(10.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.sunny,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    Text(
                                      " " + data['clouds']['all'].toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.air_outlined,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                    Text(
                                      " " +
                                          data['wind']['speed'].toString() +
                                          ' m/s',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  },
                  error: (err, s) {
                    print(err.toString());
                    return Text(err.toString());
                  },
                  loading: () => const Center(
                          child: CircularProgressIndicator(
                        color: Colors.white,
                      )))),
        ),
      ),
    );
  }
}
