import 'dart:convert';

import 'package:demo_app/screens/pdf_viewer_screen.dart';
import 'package:demo_app/widgets/action_buttons.dart';
import 'package:demo_app/widgets/image_widget.dart';
import 'package:demo_app/widgets/pdf_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:nfc_manager/nfc_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  final GlobalKey<FormState> _searchformkey = GlobalKey<FormState>();

  @override
  @override
  void initState() {
    super.initState();
  }

  bool isimagesAndPdfWidgetsDisplayed = false;

  final searchInputController = TextEditingController();
  String documentPhoto1Url = "";
  String documentPhoto2Url = "";
  String documentPhoto3Url = "";
  String documentPdf1Url = "";
  String documentPdf2Url = "";
  String documentPdf3Url = "";

  @override
  Widget build(BuildContext context) {
    var deviceScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        title: const Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  FutureBuilder<bool>(
                    future: NfcManager.instance.isAvailable(),
                    builder: (context, ss) => ss.data != true
                        ? const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Center(
                                child: Chip(
                              label: Text('NFC is not supported on this device',
                                  style: TextStyle(fontSize: 15)),
                            )),
                          )
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: SizedBox(
                              height: 100,
                              child: Flex(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                direction: Axis.vertical,
                                children: [
                                  Flexible(
                                    flex: 2,
                                    child: Container(
                                      margin: const EdgeInsets.all(4),
                                      constraints:
                                          const BoxConstraints.expand(),
                                      decoration:
                                          BoxDecoration(border: Border.all()),
                                      child: SingleChildScrollView(
                                        child: ValueListenableBuilder<dynamic>(
                                          valueListenable: result,
                                          builder: (context, value, _) =>
                                              Text('${value ?? ''}'),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: deviceScreen.width * 0.95,
                    child: Form(
                      key: _searchformkey,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        onChanged: (value) => setState(() {}),
                        validator: (value) {
                          if (value!.isNotEmpty && value.length >= 8) {
                            return null;
                          } else if (value.length < 8 && value.isNotEmpty) {
                            return "Please enter a correct tag";
                          } else {
                            return "Please enter a tag here";
                          }
                        },
                        controller: searchInputController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        autofocus: true,
                        decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.red,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              width: 1,
                              style: BorderStyle.solid,
                              color: Colors.black,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.black54),
                          ),
                          counterStyle: const TextStyle(color: Colors.black),
                          focusColor: Colors.black,
                          hintText: " Tag",
                          contentPadding: const EdgeInsets.all(15.0),
                          suffixIcon: IconButton(
                              color: Colors.black,
                              onPressed: () {
                                searchInputController.clear();
                              },
                              icon: const Icon(Icons.clear)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: const BorderSide(
                              width: 0.05,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                    color: Colors.blue,
                    iconData: Icons.nfc_rounded,
                    onPressed: _tagRead, //_tagRead,
                    text: "Scan Tag",
                  ),
                  ActionButton(
                    onPressed: () {
                      final form = _searchformkey.currentState;
                      if (form!.validate()) {
                        setState(() {
                          form.save();
                        });
                        getDocumentDetailsRequest(searchInputController.text);
                      }
                    },
                    color: Colors.green,
                    iconData: Icons.search_rounded,
                    //_tagRead,
                    text: "Consultar",
                  ),
                  ActionButton(
                    onPressed: () {
                      setState(() {
                        isimagesAndPdfWidgetsDisplayed = false;
                        searchInputController.clear();
                      });
                    },
                    color: Colors.red,
                    iconData: Icons.refresh,
                    //_tagRead,
                    text: "Refresh",
                  ),
                ],
              ),
              isimagesAndPdfWidgetsDisplayed
                  ? imagesAndPdfWidgets(context)
                  : const Padding(
                      padding: EdgeInsets.only(top: 100.0),
                      child: Text(
                          "Please enter a tag in the search bar or scan a tag"),
                    )
            ],
          ),
        ),
      ),
    );
  }

  imagesAndPdfWidgets(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 10, top: 15),
            child: Align(
              child: Chip(
                  label: Text(
                "IMAGES",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              )),
              alignment: Alignment.centerLeft,
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                ImageWidget(
                  image: documentPhoto1Url,
                ),
                ImageWidget(
                  image: documentPhoto2Url,
                ),
                ImageWidget(
                  image: documentPhoto3Url,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15.0, bottom: 10, top: 15),
            child: Align(
              child: Chip(
                  label: Text(
                "PDFs",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              )),
              alignment: Alignment.centerLeft,
            ),
          ),
          SizedBox(
            height: 400,
            child: Column(
              children: [
                PdfListWidget(
                  title: "Document 1",
                  onTap: () {
                    displayPdf(documentPdf1Url);
                  },
                ),
                PdfListWidget(
                  title: "Document 2",
                  onTap: () {
                    displayPdf(documentPdf2Url);
                  },
                ),
                PdfListWidget(
                  title: "Document 3",
                  onTap: () {
                    displayPdf(documentPdf3Url);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final String documentUrl =
      '''http://79.143.190.196:8080/jLeoniPedim/servletExtraeInfoPEdimento?xAccion=extraeDatosPedimento&xNoPEdimento=''';

  Future getDocumentDetailsRequest(String tag) async {
    var makeGetDocumentRequest = Uri.parse(documentUrl + tag);
    try {
      var documentRequestResult = await http.get(makeGetDocumentRequest);

      final documentResultJson = jsonDecode(documentRequestResult.body);
      getDocumentDetails(documentResultJson);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error getting data from server")));
    }
  }

  void getDocumentDetails(json) {
    final document = json[0];
    final documentPhoto1 = document["xFoto1"];
    final documentPhoto2 = document["xFoto2"];
    final documentPhoto3 = document["xFoto3"];
    final documentPdf1 = document["xPedimPDF1"];
    final documentPdf2 = document["xPedimPDF2"];
    final documentPdf3 = document["xPedimPDF3"];

    documentPhoto1Url = documentPhoto1;
    documentPhoto2Url = documentPhoto2;
    documentPhoto3Url = documentPhoto3;
    documentPdf1Url = documentPdf1;
    documentPdf2Url = documentPdf2;
    documentPdf3Url = documentPdf3;
    setState(() {
      isimagesAndPdfWidgetsDisplayed = true;
    });
  }

  void displayPdf(String pdfUrl) {
    Navigator.of(context).push(
  
      MaterialPageRoute(
          builder: (context) => PdfViewerWidget(documentUrl: pdfUrl)),
    );
  }

  Map nfcData = {
    "nfca": {
      "identifier": [4, 12, 48, 234, 96, 103, 129],
      "atqa": [68, 0],
      "maxTransceiveLength": 253,
      "sak": 0,
      "timeout": 618
    },
    "mifareultralight": {
      "identifier": [4, 12, 48, 234, 96, 103, 129],
      "maxTransceiveLength": 253,
      "timeout": 618,
      "type": 1
    },
    "indefformatable": {
      "identifier": [4, 12, 48, 234, 96, 103, 129]
    }
  };

  String extractNfcId() {
    final List<int> nfcId = nfcData["nfca"]["identifier"];
    final String numsToString = nfcId.join();
    return numsToString;
  }

  String convertTextToHex(nfcIdString) {
    var tagToInt = int.parse(nfcIdString);
    return tagToInt.toRadixString(8).toString();

    // var listNum = [];
    // int decimalNum, i = 0;
    // decimalNum = 105;
    // while (decimalNum != 0) {
    //   listNum.insert(i, decimalNum % 16);
    //   i++;
    //   decimalNum = (decimalNum ~/ 16).toInt();
    // }
    // num a = 0;
    // for (i = (i - 1); i >= 0; i--) {
    //   a = a * 10 + listNum[i];
    // }
    // return a.toString();
  }

  void _tagRead() {
    String nfcId = extractNfcId();
    final String convertedHex = convertTextToHex(nfcId);
    setState(
      () {
        searchInputController.text = convertedHex;
      },
    );
    // NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    //   result.value = tag.data;
    //   setState(() {
    //     searchInputController.text = "040C30EA606781";
    //   });
    //   NfcManager.instance.stopSession();
    // });
  }
}
