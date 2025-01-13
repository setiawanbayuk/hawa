// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pecut/controllers/sso_controller.dart';
import 'package:pecut/views/home/home_berita_widget.dart';
import 'package:pecut/views/home/home_layanan_widget.dart';
import 'package:pecut/views/layanan/category/layanan_category_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
      ),
    );
    return Consumer<SsoController>(builder: (context, sso, child) {
      ImageProvider avatarWidget = sso.isAuth
          ? const NetworkImage('https://randomuser.me/api/portraits/men/64.jpg')
          : const AssetImage('assets/images/logo-instansi.png');

      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: SafeArea(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: avatarWidget,
                          radius: 30.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              sso.isAuth ? sso.user.name! : 'PECUT',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white),
                            ),
                            sso.isAuth
                                ? Row(
                                    children: [
                                      const Icon(
                                        Icons.email,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        sso.user.email!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Text(
                                        'Portal Efisien Cepat Mudah Terpadu\nPemerintah Kota Kediri',
                                        style: TextStyle(
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.fontSize,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        print('Get notifications');
                      },
                      icon: const Icon(Icons.notifications),
                      color: Theme.of(context).colorScheme.primary,
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                    ),
                  ],
                )),
              ),
              Transform.translate(
                offset: const Offset(0, -25),
                child: SizedBox(
                  width: 350,
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(40),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Telusuri semua layanan digital Kota Kediri',
                        hintStyle: TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Layanan Public Digital',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return const LayananCategoryScreen(
                                      categoryName: 'Layanan Public Digital',
                                      categorySlug: 'public_digital',
                                    );
                                  }),
                                );
                              },
                              child: const Text(
                                'Lihat semua',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const HomeLayananWidget(categoryId: 1),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Layanan ASN Digital',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return const LayananCategoryScreen(
                                      categoryName: 'Layanan ASN Digital',
                                      categorySlug: 'asn_digital',
                                    );
                                  }),
                                );
                              },
                              child: const Text(
                                'Lihat semua',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const HomeLayananWidget(categoryId: 2),
                        const SizedBox(height: 30),
                        const HomeBeritaWidget(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
