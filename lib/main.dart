import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/bottom_navigation_controller.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/views/home/home_screen.dart';
import 'package:pecut/views/layanan/layanan_screen.dart';
import 'package:pecut/views/profile/profile_screen.dart';
import 'package:provider/provider.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..userAgent =
          'Mozilla/5.0 (X11; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0'
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future main() async {
  await dotenv.load(fileName: '.env');
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BottomNavigationController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => SsoController(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => EsuketController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool isLoading = context.watch<SsoController>().isLoading;

    return MaterialApp(
      title: 'PECUT',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          primary: const Color.fromRGBO(80, 77, 255, 1),
          inversePrimary: const Color.fromRGBO(195, 193, 255, 1),
          surface: Colors.grey[200],
        ),
        useMaterial3: true,
      ),
      home: isLoading ? const CircularScreen() : const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    LayananScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationController>(
        builder: (context, bottomNavigation, child) {
      return Scaffold(
        body: _widgetOptions.elementAt(bottomNavigation.selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.widgets),
              label: 'Layanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Akun',
            ),
          ],
          currentIndex: bottomNavigation.selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          onTap: bottomNavigation.handleItemTapped,
        ),
      );
    });
  }
}

class CircularScreen extends StatelessWidget {
  const CircularScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
