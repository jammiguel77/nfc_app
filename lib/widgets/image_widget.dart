import 'package:demo_app/widgets/action_buttons.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class ImageWidget extends StatelessWidget {
  const ImageWidget({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    var deviceScreen = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
        child: Container(
            height: deviceScreen.height * .3,
            width: deviceScreen.width * .9,
            decoration: ShapeDecoration(
                color: Colors.grey.shade100,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    height: 120,
                    image: NetworkImage(
                      image,
                    ),
                    errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(
                      Icons.error,
                      color: Color.fromARGB(255, 240, 106, 97),
                      size: 100,
                    )),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionButton(
                      color: Colors.green,
                      text: "Save",
                      onPressed: () {
                        downloadImage(context, image);
                      },
                      iconData: Icons.save_alt),
                  ActionButton(
                      color: Colors.red,
                      text: "Email",
                      onPressed: () async {
                        String emailResponse = await emailImage(image);
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(emailResponse)));
                      },
                      iconData: Icons.email_rounded),
                ],
              )
            ])));
  }

  void downloadImage(BuildContext context, image) async {
    GallerySaver.saveImage(image);
  }

  Future<String> emailImage(image) async {
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
        platformResponse = 'Email intent';
        break;
      default:
        platformResponse = 'unknown';
        break;
    }
    return platformResponse;
  }
}
