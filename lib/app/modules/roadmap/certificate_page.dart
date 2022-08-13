import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CertificatePage extends StatefulWidget {
  File file;
  String url;
  String roadmapName;

  CertificatePage(this.file,this.url,this.roadmapName);

  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
      appBar: AppBar(
        title: Text('My ${widget.roadmapName} Certificate'),
        actions: [
          IconButton(
            onPressed: () async {
              await saveFile(widget.url, name);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'success',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.download_rounded),
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.file.path,
      ),
    );
  }

  Future<bool> saveFile(String url, String fileName) async {
    try {
       if (await _requestPermission(Permission.storage)&&await _requestPermission(Permission.manageExternalStorage)) {
        Directory? directory;
        directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/Roadmap Certificates";
        directory = Directory(newPath);

        File saveFile = File(directory.path + "/${widget.roadmapName}.pdf");
        if (kDebugMode) {
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          log("it does not exists");
        final madeDirectory = await directory.create(recursive: true);
        log("made direcory ${madeDirectory}");
        }
        if (await directory.exists()) {
          await Dio().download(
            url,
            saveFile.path,
          );
        }
      }
      return true;
    } catch (e) {
      log("error is $e");
      return false;
    }
  }
  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }
}
