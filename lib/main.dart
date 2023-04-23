import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/models/country.dart';

import 'pages/connection/connectionPage.dart';
import 'pages/connection/signUpPage.dart';
import 'pages/countries/countriesListPage.dart';
import 'pages/weatherDetail/weatherDetailPage.dart';

void main() {
  runApp(const ProviderScope(child: const MyApp()));
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return ConnectionPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'countries-list',
          name: 'countries-list',
          builder: (BuildContext context, GoRouterState state) {
            return CountriesListPage();
          },
        ),
        GoRoute(
          path: 'signe-up',
          name: 'signe-up',
          builder: (BuildContext context, GoRouterState state) {
            return SignUpPage();
          },
        ),
        GoRoute(
          path: 'weather-detail',
          name: 'weather-detail',
          builder: (context, state) {
            Map<String, List<Country>> sample = state.extra
                as Map<String, List<Country>>; // -> casting is important
            return WeatherDetailPage(
              countries: sample,
            );
          },
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
