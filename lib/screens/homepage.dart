import 'dart:convert';

import 'package:demo_app/screens/pdf_viewer_screen.dart';
import 'package:demo_app/widgets/image_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  @override
  void initState() {
    super.initState();
  }

  bool isimagesAndPdfWidgetsDisplayed = false;

  final textInputController = TextEditingController();
  String documentPhoto1Url = "";
  String documentPhoto2Url = "";
  String documentPhoto3Url = "";
  String documentPdf1Url =
      "https://www.gob.mx/cms/uploads/attachment/file/74234/Formato-Pedimento-Aduanal.pdf";
  String documentPdf2Url =
      "https://www.gob.mx/cms/uploads/attachment/file/74234/Formato-Pedimento-Aduanal.pdf";
  String documentPdf3Url =
      "https://www.gob.mx/cms/uploads/attachment/file/74234/Formato-Pedimento-Aduanal.pdf";

  // @override
  // void dispose() {
  //   textInputController.dispose();
  //   textInputController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                            'Nfc is not Supported on this device ',
                            style: TextStyle(color: Colors.red, fontSize: 15),
                          )),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: SizedBox(
                            height: 100,
                            child: Flex(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              direction: Axis.vertical,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    constraints: const BoxConstraints.expand(),
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
                const Text(
                  "Tag:",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: 40,
                  width: 250,
                  child: TextField(
                    controller: textInputController,
                    autofocus: true,
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      contentPadding: const EdgeInsets.all(15.0),
                      suffixIconColor: Colors.black87,
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
                const SizedBox(),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _tagRead,
                  child: const Text("Scan Tag"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    getDocumentDetailsRequest(textInputController.text);
                  },
                  child: const Text("Consultar"),
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
              child: Text(
                "Images",
                style: TextStyle(fontSize: 22),
              ),
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
              child: Text(
                "PDFs",
                style: TextStyle(fontSize: 22),
              ),
              alignment: Alignment.centerLeft,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Divider(
              color: Colors.black,
              height: 5,
            ),
          ),
          SizedBox(
            height: 400,
            child: Column(
              children: [
                ListTile(
                  title: const Text("Document 1"),
                  subtitle: const Text("Pdf"),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    displayPdf(documentPdf1Url);
                  },
                ),
                ListTile(
                  title: const Text("Document 2"),
                  subtitle: const Text("Pdf"),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    displayPdf(documentPdf2Url);
                  },
                ),
                ListTile(
                  title: const Text("Document 3"),
                  subtitle: const Text("Pdf"),
                  trailing: const Icon(Icons.open_in_new),
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
    var documentRequestResult = await http.get(makeGetDocumentRequest);
    final documentResultJson = jsonDecode(documentRequestResult.body);
    getDocumentDetails(documentResultJson);
  }

  void getDocumentDetails(json) {
    final document = json[0];
    final documentPhoto1 = document["xFoto1"];
    final documentPhoto2 = document["xFoto2"];
    final documentPhoto3 = document["xFoto3"];
    final documentPdf1 = document["xPedimPDF1"];
    final documentPdf2 = document["xPedimPDF2"];
    final documentPdf3 = document["xPedimPDF3"];

    setState(() {
      isimagesAndPdfWidgetsDisplayed = true;
      documentPhoto1Url = documentPhoto1;
      documentPhoto2Url = documentPhoto2;
      documentPhoto3Url = documentPhoto3;
      documentPdf1Url = documentPdf1;
      documentPdf2Url = documentPdf2;
      documentPdf3Url = documentPdf3;
    });
  }

  void displayPdf(String pdfUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PdfViewerWidget(documentUrl: pdfUrl)),
    );
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
setState((){
textInputController.text="040C30EA606781"});
      NfcManager.instance.stopSession();
    });
  }
}
