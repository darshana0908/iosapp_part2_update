// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:file_cryptor/file_cryptor.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:safe_encrypt/db/sqldb.dart';

class FileService {
  final String pinNumber;
  final String title;
  final String pathfolder;

  FileService({required this.pinNumber, required this.title, required this.pathfolder});

  // getting the default folder for each folder types (real and fake)
  String getFolderPath() => '/storage/emulated/0/Android/data/com.example.safe_encrypt/files/safe/app/new/$pinNumber/Main Album/';
  SqlDb sqlDb = SqlDb();
  // importing files
  Future<void> importFiles() async {
    String fileName = '';

    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();

      for (File file in files) {
        fileName = path.basename(file.path);

        File fileToSave = File(file.path);
        fileToSave.copy('${getFolderPath()}$fileName');

        log(files.toString());

        await encryptFiles(fileName, '$fileName.aes', getFolderPath());

        delete('${getFolderPath()}$fileName');
      }
    } else {
      // User canceled the picker
    }
  }

  Future<File> encryptFiles(String inputFileName, String outputFileName, String directory) async {
    FileCryptor fileCryptor = FileCryptor(
      key: 'Your 32 bit key.................',
      iv: 16,
      dir: directory,
    );

    return fileCryptor.encrypt(inputFile: inputFileName, outputFile: outputFileName);
  }

// deleting files
  void delete(String path) {
    final dir = Directory(path);
    dir.deleteSync(recursive: true);
  }
}
