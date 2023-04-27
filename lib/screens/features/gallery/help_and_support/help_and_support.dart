import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:safe_encrypt/constants/colors.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            AppBar(backgroundColor: kdarkblue, title: Text('Help And Support')),
        body: Padding(
          padding: const EdgeInsets.all(32.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                'What is Keepsafe?',
                style: TextStyle(fontSize: 20, color: kdarkblue),
              ),
              Divider(),
              Text(
                'Keepsafe Photo Vault is a simple privacy and security app. Keepsafe provides a protected space on your iPhone, Android, or tablet to keep important things safe like private photos, videos and files. Keepsafe uses military grade encryption. To ensure privacy, Keepsafe has no system IT admins or employees that can access or view your content.',
                style: TextStyle(fontSize: 16),
              ),
              Divider(),
              Text(
                'What is a photo vault?',
                style: TextStyle(fontSize: 20, color: kdarkblue),
              ),
              Divider(),
              Text(
                'A photo vault is a privacy app for your mobile device to protect photos, videos and documents. Putting your private pictures into a photo vault adds them to an encrypted, password-protected locker that keeps them safe and secure from prying eyes. In addition, you can choose to backup your files for added security. Using a photo vault can also save storage space on your device. The benefits vary depending upon which photo vault app you choose.',
                style: TextStyle(fontSize: 16),
              ),
              Divider(),
              Text(
                'Supported media & file types',
                style: TextStyle(fontSize: 20, color: kdarkblue),
              ),
              Divider(),
              Text(
                'Photos',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                ' . jpg \n . png \n . jpeg \n',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Videos',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '. 3gp \n. m4v \n. mkv \n. mp4 \n. webm \n. avi',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Documents',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '. pdf \n. txt ',
                style: TextStyle(fontSize: 16),
              ),
              Divider(),
              Text(
                'Adding Photos to Photo Vault',
                style: TextStyle(fontSize: 20, color: kdarkblue),
              ),
              Divider(),
              Text(
                ' 1 .Tap on the ‘+’ button\n 2 .Tap on import photos & videos \n 3 .Select from where you would like to find that photo',
                style: TextStyle(fontSize: 16),
              ),
              Divider(),
              Text(
                'Delete Folder',
                style: TextStyle(fontSize: 20, color: kdarkblue),
              ),
              Divider(),
              Text(
                ' 1 .Tap on the  folder \n 2 .Tap on the delete ',
                style: TextStyle(fontSize: 16),
              ),
              Divider(),
              Text(
                'Delete photo file or video',
                style: TextStyle(fontSize: 20, color: kdarkblue),
              ),
              Divider(),
              Text(
                ' 1 .Double Tap on the  photo file or video ',
                style: TextStyle(fontSize: 16),
              ),
              Divider(),
              Text(
                'Create new account',
                style: TextStyle(fontSize: 20, color: kdarkblue),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    ' 1 . Tap on the this icon',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Icon(Icons.density_medium_rounded)
                ],
              ),
              Text(
                ' 2 . Tap on the Create New Vault',
                style: TextStyle(fontSize: 16),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
