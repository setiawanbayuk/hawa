// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

final dio = Dio();

class HomeBeritaWidget extends StatefulWidget {
  const HomeBeritaWidget({super.key});

  @override
  State<HomeBeritaWidget> createState() => _HomeBeritaWidgetState();
}

class _HomeBeritaWidgetState extends State<HomeBeritaWidget> {
  final _controller = PageController(viewportFraction: 0.8, keepPage: true);

  Future fetchData() async {
    try {
      String url =
          'https://api-splp.layanan.go.id:443/t/kedirikota.go.id/web_kediri_kota/1.0/api/berita';
      Response response = await dio.get(url);
      List decoded = jsonDecode(response.data['berita']);
      return decoded;
    } on DioException catch (e) {
      print('fetchBeritaFailed: ${e.response?.data?.toString()}');
    }
  }

  Future _launchUrl(String id, String url) async {
    Uri uri = Uri.parse('https://kedirikota.go.id/p/berita/$id/$url');
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Berita Teratas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            IconButton(
              onPressed: () => fetchData(),
              icon: const Icon(Icons.refresh, size: 20),
            ),
          ],
        ),
        const SizedBox(height: 15),
        FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              List items = snapshot.data;
              return SizedBox(
                height: 230,
                child: PageView.builder(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    final pages = List.generate(
                      items.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _launchUrl(
                            items[index]['idpost'],
                            items[index]['judulurl'],
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: Column(
                            children: [
                              Container(
                                height: 125,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        items[index]['linkgambar']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items[index]['judul'],
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 7),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Icon(Icons.calendar_today,
                                            size: 14),
                                        const SizedBox(width: 7),
                                        Text(
                                          DateFormat('dd MMM yyyy')
                                              .format(DateTime.parse(
                                                  items[index]['tgl']))
                                              .toString(),
                                          style: const TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    return pages[index % items.length];
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Cannot load data.');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ],
    );
  }
}
