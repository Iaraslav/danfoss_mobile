import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// An abstract class that defines a service for handling permissions.
///
/// Subclasses must implement the [requestPermission] method, which requests the necessary permission from the user.
abstract class PermissionService {
  
  /// Requests the required permission from the user.
  /// 
  /// This method needs to be implemented by any subclass to handle specific permissions (for example, Camera and Gallery).
  Future<void> requestPermission(BuildContext context);

  /// Shows a dialog informing the user that a permission was denied.
  ///
  /// The [message] parameter is the message displayed in the dialog.
  /// The [openSettings] parameter determines if a "Settings" button is shown, allowing the user to open app settings.
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

/// A service for handling camera permissions.
class CameraPermissionService extends PermissionService {
  
  /// Requests camera permission from the user.
  ///
  /// If the permission is denied, a dialog is shown to the user. If the permission is
  /// permanently denied, the dialog includes an option to open the app settings.
  @override
  Future<void> requestPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.camera.request();

    // Log the camera permission status for debugging.
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

/// A service for handling gallery permissions.
class GalleryPermissionService extends PermissionService {
  
  /// Requests gallery permission from the user.
  ///
  /// If the permission is denied, a dialog is shown to the user. If the permission is
  /// permanently denied, the dialog includes an option to open the app settings.
  @override
  Future<void> requestPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.photos.request();
    
    // Log the gallery permission status for debugging.
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

/// A service for handling file storage permissions.
class FilePermissionService extends PermissionService {
  
  /// Requests file storage permission from the user.
  ///
  /// If the permission is denied, a dialog is shown to the user. If the permission is
  /// permanently denied, the dialog includes an option to open the app settings.
  @override
    Future<void> requestPermission(BuildContext context) async {
    final PermissionStatus status = await Permission.storage.request();

    // Log the storage permission status for debugging.
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