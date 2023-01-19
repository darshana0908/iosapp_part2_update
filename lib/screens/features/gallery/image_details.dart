import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../constants/colors.dart';

class ImageDetails extends StatefulWidget {
  final String path;
  final Function getbool;
  const ImageDetails({Key? key, required this.path, required this.getbool}) : super(key: key);

  @override
  State<ImageDetails> createState() => _ImageDetailsState();
}

class _ImageDetailsState extends State<ImageDetails> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    // TODO: implement
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
              // backgroundColor: kblack,
              ),
          backgroundColor: kblack,
          body: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 0.25).animate(_controller),
                    child: Center(
                      child: Image.file(
                        File(widget.path), //system image path
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
              // Center(
              //     child: Image.file(
              //   File(widget.path), //system image path
              //   fit: BoxFit.cover,
              // )),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            color: kblack,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              IconButton(
                onPressed: () async {
                  final temp = await getTemporaryDirectory();

                  // await Share.shareFiles([widget.path], text: 'check out my Apps https://Safeloging.com');
                },
                icon: Icon(
                  Icons.share,
                  color: kwhite,
                ),
                iconSize: 30,
              ),
              IconButton(
                onPressed: () {
                  _controller.forward();
                },
                icon: Icon(
                  Icons.rotate_90_degrees_ccw_outlined,
                  color: kwhite,
                ),
                iconSize: 30,
              ),
              ElevatedButton(
                child: const Text("reset"),
                onPressed: () => _controller.reset(),
              ),
              InkWell(
                onTap: () async {
                  String folder = '';

                  setState(() => delete(widget.path));
                  // Navigator.push(context, MaterialPageRoute(builder: (_) => ImageScreen(title: folder, path: widget.path)));
                },
                child: Icon(
                  Icons.delete_forever,
                  color: kwhite,
                  size: 30,
                ),
              ),
            ]),
          )),
    );
  }

  void delete(String path) {
    final decryptedDir = Directory(path);
    final encryptedDir = Directory('$path.aes');
    setState(() {
      encryptedDir.deleteSync(recursive: true);

      decryptedDir.deleteSync(recursive: true);
    });
  }
}
