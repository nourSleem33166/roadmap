import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../shared/toasts/messages_toasts.dart';

class CertificatePage extends StatefulWidget {
  File file;
  String url;
  String roadmapName;

  CertificatePage(this.file, this.url, this.roadmapName);

  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  @override
  Widget build(BuildContext context) {
    final name = basename(widget.file.path);
    return Scaffold(
        appBar: AppBar(title: Text('My ${widget.roadmapName} Certificate'), actions: [
          IconButton(
              onPressed: () async {
                await saveFile(widget.url, name);
              },
              icon: const Icon(Icons.download_rounded))
        ]),
        body: InteractiveViewer(child: PDFView(filePath: widget.file.path)));
  }

  Future<bool> saveFile(String url, String fileName) async {
    try {
      if (await _requestPermission(Permission.storage) &&
          await _requestPermission(Permission.manageExternalStorage) &&
          await _requestPermission(Permission.accessMediaLocation)) {
        String? baseDir;
        baseDir = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);

        final newPath = baseDir + "/Roadmap Certificates";
        final directory = Directory(newPath);

        File saveFile = File(directory.path +
            "/${widget.roadmapName.replaceAll('|', '_').replaceAll(' ', '_')}.pdf");
        if (kDebugMode) {
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          log("it does not exists");
          final madeDirectory = await directory.create(recursive: true);
          log("made direcory ${madeDirectory}");
        }
        if (await directory.exists()) {
          await startDownloading(url, saveFile.path);
        }
      }
      return true;
    } catch (e) {
      log("error is $e");
      showErrorToast(e.toString());
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

  Future startDownloading(String url, String path) async {
    await Dio().download(url, path);
  }
}
