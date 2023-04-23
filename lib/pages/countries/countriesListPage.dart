import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/country.dart';
import '../../utils/remoteData.dart';

final countriesDataProvider = FutureProvider<List<Country>>((ref) {
  final region00 = ref.watch(searchProvider);
  return ref.watch(countriesProvider).getAllCountries(region00);
});
final weatherDataProvider =
    FutureProvider.family<Map, List<double>>((ref, latlang) async {
  return ref.watch(countriesProvider).getCountryWeather(latlang);
});

final searchProvider = StateProvider<String>(
  // We return the default sort type, here name.
  (ref) => "",
);

final List<AsyncValue<Map>> weatherProviderList = [];

class CountriesListPage extends ConsumerWidget {
  CountriesListPage({super.key});
  Future<List<Country>> _futureCountries = Future.value([]);
  List<Future<Map>> _countriesweather = [];
  RemoteData _remoteData = RemoteData();
  TextEditingController _controller = TextEditingController();

  // Card ontap function
  void gotoCountryDetail(
      List<Country> countries, int index, BuildContext context) {
    Map<String, List<Country>> map00 = {
      "CURRENT": [countries[index]],
      "ALL": countries
    };
    context.goNamed("weather-detail", extra: map00);
  }

  // I used 2 future providers to separate loading the capitals and the weather.
  // I fetch all the capitals at the same time, but I fetch only the visible capital weather. this is faster than fetching all the data at the same time.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _data1 = ref.watch(countriesDataProvider);
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 20,
            backgroundColor: Colors.white,
            shadowColor: Colors.white,
            bottomOpacity: 0.0,
            elevation: 0.0,
          ),
          body: Container(
            color: Colors.white,
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          color: Colors.orange.shade600,
                          size: 26,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          borderSide:
                              BorderSide(width: 1, color: Colors.grey.shade400),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(width: 1, color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.orange.shade600, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        labelText: 'Search country capitals by region',
                        fillColor: Colors.white),
                    onChanged: (text) async {
                      ref.read(searchProvider.notifier).state = text;
                    }),
                Expanded(
                    child: _data1.when(
                        data: (data1) {
                          List<Country> countries =
                              data1.map((c) => c).toList();
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 8.0),
                            itemCount: countries.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () => {
                                        gotoCountryDetail(
                                            countries, index, context)
                                      },
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      child: Container(
                                        height: 180,
                                        padding: const EdgeInsets.all(20.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 10),
                                                    child: Icon(
                                                      Icons.location_on_sharp,
                                                      color:
                                                          Colors.blue.shade700,
                                                      size: 32,
                                                    ),
                                                  ),
                                                  Flexible(
                                                      fit: FlexFit.loose,
                                                      child: Text(
                                                        countries[index].NAME,
                                                        style: TextStyle(
                                                          fontSize: 22,
                                                          color: Colors
                                                              .blue.shade700,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        softWrap: false,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ref
                                                    .watch(weatherDataProvider(
                                                        countries[index]
                                                            .LATLNG))
                                                    .when(
                                                      data: (_data2) {
                                                        Map weather = _data2;
                                                        return Column(
                                                          children: [
                                                            Image.network(
                                                              "https://openweathermap.org/img/wn/" +
                                                                  weather['weather']
                                                                          [0]
                                                                      ['icon'] +
                                                                  "@2x.png",
                                                              width: 86,
                                                              height: 86,
                                                            ),
                                                            Text(
                                                              countries[index]
                                                                  .CAPITAL,
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                            Text(
                                                              '${weather['main']['temp'].round()} degrees',
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                                color: Colors
                                                                    .grey
                                                                    .shade700,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                      loading: () => const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                      error: (err, s) =>
                                                          Text(err.toString()),
                                                    )
                                              ],
                                            )
                                          ],
                                        ),
                                      )));
                            },
                          );
                        },
                        error: (err, s) => Text(err.toString()),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()))),
              ],
            ),
          ),
        ));
  }
}
