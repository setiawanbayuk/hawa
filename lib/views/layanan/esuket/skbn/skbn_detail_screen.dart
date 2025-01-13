// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:provider/provider.dart';

final dio = Dio();

class EsuketSkbnDetailScreen extends StatelessWidget {
  final int id;
  const EsuketSkbnDetailScreen({
    super.key,
    required this.id,
  });

  Future fetchData(String nik, String token) async {
    print('fetching data...');
    String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skbn?nik=$nik';
    Response response = await dio.get(
      url,
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      ),
    );

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EsuketController>(
      builder: (context, esuket, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Detail Pengajuan: ${id.toString()}'),
          ),
          body: FutureBuilder(
            future: fetchData(esuket.user!.nik!, esuket.token),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                List items = List.from(snapshot.data)
                    .where((item) => item['id'] == id)
                    .toList();
                Map<String, dynamic> item = items[0];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Wrap(
                    runSpacing: 10,
                    children: [
                      Material(
                        elevation: 0.1,
                        borderRadius: BorderRadius.circular(10),
                        child: ListTile(
                          title: const Text('Nomor Surat:'),
                          subtitle: Text(item['nomor_surat']),
                          tileColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Card(
                        color: Colors.white,
                        elevation: 0.1,
                        child: Wrap(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ContentWidget(
                                    value: item['kepada'],
                                    label: 'Kepada:',
                                  ),
                                ),
                                Expanded(
                                  child: ContentWidget(
                                    value: item['nik'],
                                    label: 'NIK:',
                                  ),
                                ),
                              ],
                            ),
                            ContentWidget(
                              value: item['peruntukan'],
                              label: 'Peruntukan:',
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: ContentWidget(
                                    value: item['tgl_surat'],
                                    label: 'Tgl. Surat:',
                                  ),
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: const Text('File:'),
                                    subtitle: item['file'] != null
                                        ? Row(
                                            children: [
                                              TextButton(
                                                child: const Text(
                                                  'Download',
                                                  style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  print(
                                                    'readyToDownload: ${item['file']}',
                                                  );
                                                },
                                              ),
                                            ],
                                          )
                                        : const Text('-'),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Image(
                                    image: NetworkImage(
                                      '${dotenv.env['ESUKET_BASE_URL']!}${item['pengantar']}',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      },
    );
  }
}

class ContentWidget extends StatelessWidget {
  final dynamic value;
  final String label;
  const ContentWidget({
    super.key,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
    );
  }
}
