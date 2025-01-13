// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:pecut/views/layanan/category/layanan_category_screen.dart';
import 'package:pecut/views/layanan/layanan_asn_digital_widget.dart';
import 'package:pecut/views/layanan/layanan_public_digital_widget.dart';

class LayananScreen extends StatelessWidget {
  const LayananScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Stack(
        children: [
          Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 1,
                child: LayananPublicDigitalWidget(
                  onTap: (route) {
                    // print('navigateTo: $route');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LayananCategoryScreen(
                          categorySlug: route,
                          categoryName: 'Public Digital',
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 1,
                child: LayananAsnDigitalWidget(
                  onTap: (route) {
                    // print('navigateTo: $route');
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LayananCategoryScreen(
                          categorySlug: route,
                          categoryName: 'ASN Digital',
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height / 2.9,
            left: 0,
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 75,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Transform.translate(
                    offset: const Offset(0, 20),
                    child: Text(
                      'PEMERINTAH KOTA KEDIRI',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: const Image(
                      image: AssetImage('assets/images/logo-instansi.png'),
                      width: 55,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -15),
                    child: const Text(
                      'KEDIRI THE SERVICE CITY',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
