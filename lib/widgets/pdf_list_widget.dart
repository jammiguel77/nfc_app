import 'package:flutter/material.dart';

class PdfListWidget extends StatelessWidget {
  const PdfListWidget({Key? key, required this.title, required this.onTap})
      : super(key: key);
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      leading: const Icon(
        Icons.picture_as_pdf_rounded,
        size: 25,
        color: Colors.black,
      ),
      trailing: const Icon(
        Icons.open_in_browser_rounded,
        size: 25,
        color: Colors.black,
      ),
      onTap: onTap,
    );
  }
}
