import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: GestureDetector(
          onTap: () => showImageBottomSheet(context, image),
          child: Image(
            image: NetworkImage(
              image,
            ),
            errorBuilder: (context, error, stackTrace) => const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.error, color: Colors.red),
            ),
          )),
    );
  }

  Future<void> showImageBottomSheet(BuildContext context, image) {
    return showModalBottomSheet<void>(
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 120,
            child: Column(
              children: [
                ListTile(
                  title: const Text("Download Image"),
                  onTap: () {
                    downloadImage(context, image);
                  },
                  leading: const Icon(Icons.save),
                ),
                ListTile(
                  title: const Text("Email Image"),
                  onTap: () {
                    emailImage(image);
                  },
                  leading: const Icon(Icons.email_rounded),
                ),
              ],
            ),
          );
        });
  }

  void downloadImage(BuildContext context, image) async {
    GallerySaver.saveImage(image);
    Navigator.pop(context);
  }

  void emailImage(image) async {
    final MailOptions mailOptions = MailOptions(
      body: '',
      subject: '',
      recipients: [''],
      isHTML: true,
      attachments: [
        image,
      ],
    );

    final MailerResponse response = await FlutterMailer.send(mailOptions);
    String platformResponse = "";
    switch (response) {
      case MailerResponse.saved:

        /// ios only
        platformResponse = 'mail was saved to draft';
        break;
      case MailerResponse.sent:

        /// ios only
        platformResponse = 'mail was sent';
        break;
      case MailerResponse.cancelled:

        /// ios only
        platformResponse = 'mail was cancelled';
        break;
      case MailerResponse.android:
        platformResponse = 'intent was successful';
        break;
      default:
        platformResponse = 'unknown';
        break;
    }
  }
}
