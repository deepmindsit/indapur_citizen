import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:indapur_citizen/config/exported_path.dart';
import 'package:ui_package/ui_package.dart';

Future<void> handleUpdate(dynamic data) async {
  if (data == null || data['version'] == null) return;

  final info = await PackageInfo.fromPlatform();
  final String currentVersion = info.version;
  final String latestVersion = data['version'];

  final bool isUpdateAvailable =
      compareVersions(latestVersion, currentVersion) > 0;

  if (isUpdateAvailable && data['show_popup'] == true) {
    showUpdateDialog(data);
  }

  // if (Platform.isIOS) {
  //   bool isNewVersion = isVersionGreaterThan(latestVersion, currentVersion);
  //   if (isNewVersion) {
  //     data['show_popup'] == true ? showUpdateDialog(data) : null;
  //   }
  // } else {
  //   int apiVersion = versionToInt(latestVersion);
  //
  //   int systemVersion = versionToInt(currentVersion);
  //
  //   if (apiVersion > systemVersion) {
  //     data['show_popup'] == true ? showUpdateDialog(data) : null;
  //   }
  // }
}

int compareVersions(String newVersion, String oldVersion) {
  try {
    List<int> newParts = newVersion
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    List<int> oldParts = oldVersion
        .split('.')
        .map((e) => int.tryParse(e) ?? 0)
        .toList();

    int maxLength = newParts.length > oldParts.length
        ? newParts.length
        : oldParts.length;

    for (int i = 0; i < maxLength; i++) {
      int newVal = i < newParts.length ? newParts[i] : 0;
      int oldVal = i < oldParts.length ? oldParts[i] : 0;

      if (newVal > oldVal) return 1;
      if (newVal < oldVal) return -1;
    }

    return 0;
  } catch (e) {
    return 0; // fallback safe
  }
}

bool isVersionGreaterThan(String newVersion, String oldVersion) {
  List<String> newVersionParts = newVersion.split('.');
  List<String> oldVersionParts = oldVersion.split('.');

  if (int.parse(newVersionParts[0]) > int.parse(oldVersionParts[0])) {
    return true;
  } else if (int.parse(newVersionParts[0]) < int.parse(oldVersionParts[0])) {
    return false;
  }

  if (int.parse(newVersionParts[1]) > int.parse(oldVersionParts[1])) {
    return true;
  } else if (int.parse(newVersionParts[1]) < int.parse(oldVersionParts[1])) {
    return false;
  }
  return false;
}

int versionToInt(String version) {
  List<String> parts = version.split('.');
  int major = int.parse(parts[0]);
  int minor = int.parse(parts[1]);
  int patch = int.parse(parts[2]);
  return major * 1000000 + minor * 1000 + patch;
}

void showUpdateDialog(Map<String, dynamic> data) {
  if (Platform.isIOS) {
    /// 🍎 iOS Style Dialog
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text(
          'Update Available',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Text(
            'A new version of the app is available. Please update to continue.',
          ),
        ),
        actions: [
          /// 🔹 Update Button
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {
              final url = data['url'];
              if (url != null) {
                await launchInBrowser(Uri.parse(url));
              }
            },
            child: const Text('Update'),
          ),

          // /// 🔹 Force Update → Exit
          // if (data['force_update'] == true)
          //   CupertinoDialogAction(
          //     isDestructiveAction: true,
          //     onPressed: () => SystemNavigator.pop(),
          //     child: const Text('Exit App'),
          //   ),

          /// 🔹 Optional Update → Skip
          if (data['force_update'] == false)
            CupertinoDialogAction(
              onPressed: () => Get.back(),
              child: const Text('Later'),
            ),
        ],
      ),
      barrierDismissible: false,
    );
  } else {
    /// 🤖 Android Style Dialog
    Get.dialog(
      AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          'Update Available',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'A new version of the app is available. Please update for the best experience.',
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final url = data['url'].toString();
              if (url.isNotEmpty) {
                await launchInBrowser(Uri.parse(url));
              }
            },
            child: const Text(
              'Update',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
          if (data['force_update'] == true)
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text(
                'Exit App',
                style: TextStyle(color: Colors.red),
              ),
            ),
          if (data['force_update'] == false)
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Later', style: TextStyle(color: Colors.grey)),
            ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
