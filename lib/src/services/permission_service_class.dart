import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionService {
  Future<void> requestPermission(BuildContext context);

  void _showPermissionDialog(BuildContext context, String message,
   {bool openSettings = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Denied"),
          content: Text(message),
          actions: [
            if (openSettings)
              TextButton(
                child: const Text("Settings"),
                onPressed: () {
                  openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class CameraPermissionService extends PermissionService {
  @override
  Future<void> requestPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.camera.request();

    log(status.toString());

    if (status.isDenied) {
      _showPermissionDialog(context, "Camera permission is denied.");
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(
          context, 
          "Camera permission is permanently denied. Please allow it in settings.",
          openSettings: true);
    }
  }
}

class GalleryPermissionService extends PermissionService {
  @override
  Future<void> requestPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.photos.request();

    log(status.toString());

    if (status.isDenied) {
      _showPermissionDialog(context, "Gallery permission is denied.");
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(
          context, 
          "Gallery permission is permanently denied. Please allow it in settings.",
          openSettings: true);
    }
  }
}

class FilePermissionService extends PermissionService {
  @override
    Future<void> requestPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.storage.request();

    log(status.toString());

    if (status.isDenied) {
      _showPermissionDialog(context, "Permisson for storage access is denied.");
    } else if (status.isPermanentlyDenied) {
      _showPermissionDialog(
          context, 
          "Permisson for storage access is permanently denied. Please allow it in settings.",
          openSettings: true);
    }
  }

}