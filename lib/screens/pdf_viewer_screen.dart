import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PdfViewerWidget extends StatefulWidget {
  const PdfViewerWidget({Key? key, required this.documentUrl})
      : super(key: key);
  final String documentUrl;

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  bool isLoading = true;
  var document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pdf"),
      ),
      body: Center(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PDFViewer(
                document: document,
                lazyLoad: false,
                scrollDirection: Axis.vertical,
              ),
      ),
    );
  }

  void loadDocument() async {
    document = await PDFDocument.fromURL(widget.documentUrl);

    setState(() {
      isLoading = false;
    });
  }
}
