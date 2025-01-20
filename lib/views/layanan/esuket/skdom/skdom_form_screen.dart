// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pecut/controllers/esuket_controller.dart';
import 'package:pecut/widgets/form_upload_widget.dart';
import 'package:pecut/widgets/text_form_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

const String title = 'Surat Keterangan Domisili';
final _formKey = GlobalKey<FormState>();
final dio = Dio();

class EsuketSkdomFormScreen extends StatefulWidget {
  final int? id;
  const EsuketSkdomFormScreen({super.key, this.id});

  @override
  State<EsuketSkdomFormScreen> createState() => _EsuketSkdomFormScreenState();
}

class _EsuketSkdomFormScreenState extends State<EsuketSkdomFormScreen> {
  TextEditingController nikCtrl = TextEditingController();
  TextEditingController kepadaCtrl = TextEditingController();
  TextEditingController peruntukanCtrl = TextEditingController();
  TextEditingController pengantarCtrl = TextEditingController();
  TextEditingController alamatCtrl = TextEditingController();
  String registerAsCtrl = 'perorangan';
  TextEditingController namaPerusahaanCtrl = TextEditingController();
  TextEditingController statusBangunanCtrl = TextEditingController();
  TextEditingController jumlahKaryawanCtrl = TextEditingController();
  File? fileUpload;
  bool isLoadingSubmit = false;

  Future handleFileUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      print('filePicker: ${file.path}');
      pengantarCtrl.text = result.files.first.name;
      setState(() {
        fileUpload = file;
      });
    } else {
      // User canceled the picker
      print('filePicker: user canceled the picker!');
    }
  }

  Future handleSubmit() async {
    setState(() {
      isLoadingSubmit = true;
    });
    try {
      String? esuketToken = await EsuketController().getToken();
      FormData formData = FormData.fromMap({
        'nik': nikCtrl.text,
        'kepada': kepadaCtrl.text,
        'peruntukan': peruntukanCtrl.text,
        'pengantar': await MultipartFile.fromFile(fileUpload!.path,
            filename: pengantarCtrl.text),
        'alamat_domisili': alamatCtrl.text,
        'register_as': registerAsCtrl,
        'nama_perusahaan': namaPerusahaanCtrl.text,
        'status_bangunan': statusBangunanCtrl.text,
        'jumlah_karyawan': jumlahKaryawanCtrl.text,
      });
      String url = '${dotenv.env['ESUKET_BASE_URL']}/api/skdom';
      Response response = await dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $esuketToken',
          },
        ),
      );
      handleSnackbar(context, response.data['message']);
      setState(() {
        isLoadingSubmit = false;
      });
    } on DioException catch (e) {
      setState(() {
        isLoadingSubmit = false;
      });
      print(
          'errorSubmit: ${e.response == null ? e.message : e.response?.data.toString()}');
    }
  }

  void handleSnackbar(BuildContext content, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      registerAsCtrl = 'perorangan';
    });
  }

  @override
  void dispose() {
    nikCtrl.dispose();
    kepadaCtrl.dispose();
    peruntukanCtrl.dispose();
    pengantarCtrl.dispose();
    alamatCtrl.dispose();
    namaPerusahaanCtrl.dispose();
    statusBangunanCtrl.dispose();
    jumlahKaryawanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EsuketController>(
      builder: (context, esuket, child) {
        nikCtrl.text = esuket.user!.nik!;
        kepadaCtrl.text = esuket.user!.name!;

        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(esuket.appName),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Form',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Buat $title',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Form(
                              key: _formKey,
                              child: Wrap(
                                runSpacing: 15,
                                children: [
                                  TextFormFieldWidget(
                                    attributeCtrl: nikCtrl,
                                    labelText: 'NIK',
                                    iconData: Icons.badge,
                                    isRequired: true,
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: kepadaCtrl,
                                    labelText: 'Kepada',
                                    iconData: Icons.more_horiz,
                                    isRequired: true,
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: peruntukanCtrl,
                                    labelText: 'Peruntukan',
                                    iconData: Icons.more_horiz,
                                    isRequired: true,
                                  ),
                                  FormUploadWidget(
                                    label: const Text.rich(
                                      TextSpan(
                                        text: 'Upload file pengantar',
                                        children: [
                                          TextSpan(
                                            text: ' *',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                    fileImage: fileUpload,
                                    onTap: () => handleFileUpload(),
                                    onDelete: () {
                                      setState(() {
                                        fileUpload = null;
                                      });
                                    },
                                  ),
                                  TextFormFieldWidget(
                                    attributeCtrl: alamatCtrl,
                                    labelText: 'Alamat',
                                    textInputType: TextInputType.multiline,
                                    iconData: Icons.more_horiz,
                                    isRequired: true,
                                    minLines: 2,
                                  ),
                                  ToggleSwitch(
                                    initialLabelIndex:
                                        registerAsCtrl == 'perorangan' ? 0 : 1,
                                    fontSize: 16,
                                    minWidth: double.infinity,
                                    minHeight: 55,
                                    activeBgColor: [
                                      Colors.black.withAlpha(150)
                                    ],
                                    inactiveBgColor: Colors.white,
                                    labels: const ['Perorangan', 'Perusahaan'],
                                    icons: const [
                                      Icons.person,
                                      Icons.apartment
                                    ],
                                    iconSize: 22,
                                    onToggle: (index) {
                                      setState(() {
                                        registerAsCtrl = index == 0
                                            ? 'perorangan'
                                            : 'perusahaan';
                                      });
                                    },
                                  ),
                                  Builder(
                                    builder: (context) {
                                      if (registerAsCtrl == 'perusahaan') {
                                        return Wrap(
                                          runSpacing: 15,
                                          children: [
                                            TextFormFieldWidget(
                                              attributeCtrl: namaPerusahaanCtrl,
                                              labelText: 'Nama Perusahaan',
                                              iconData: Icons.more_horiz,
                                              isRequired: registerAsCtrl ==
                                                  'perusahaan',
                                            ),
                                            TextFormFieldWidget(
                                              attributeCtrl: statusBangunanCtrl,
                                              labelText: 'Status Bangunan',
                                              iconData: Icons.more_horiz,
                                              isRequired: registerAsCtrl ==
                                                  'perusahaan',
                                            ),
                                            TextFormFieldWidget(
                                              attributeCtrl: jumlahKaryawanCtrl,
                                              labelText: 'Jumlah Karyawan',
                                              iconData: Icons.more_horiz,
                                              isRequired: registerAsCtrl ==
                                                  'perusahaan',
                                              textInputType:
                                                  TextInputType.number,
                                            ),
                                            const SizedBox(height: 75),
                                          ],
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: ButtonStyle(
                        padding: const WidgetStatePropertyAll(
                          EdgeInsets.symmetric(vertical: 15),
                        ),
                        shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.primary,
                        ),
                        overlayColor: WidgetStatePropertyAll(
                          Colors.black.withOpacity(0.2),
                        ),
                        foregroundColor:
                            const WidgetStatePropertyAll(Colors.white),
                      ),
                      onPressed: () {
                        if (pengantarCtrl.text.isEmpty) {
                          print('upload file dulu woy!!!');
                        }
                        if (_formKey.currentState!.validate() &&
                            fileUpload != null) {
                          print('you tapped the submit button');
                          handleSubmit();
                        }
                      },
                      label: const Icon(Icons.check),
                      icon: Text(
                        isLoadingSubmit ? 'Processing...' : 'Submit',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
