import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:ui_package/ui_package.dart';
import '../config/exported_path.dart';

class AllDialogs {
  Future<void> noInternetDialog() async {
    await Get.dialog(
      PopScope(
        canPop: false,
        child: GetPlatform.isIOS
            ? CupertinoAlertDialog(
                title: const Text('No Internet Connection'),
                content: Column(
                  children: [
                    const SizedBox(height: 10),
                    Image.asset(Images.noInternet, height: Get.height * 0.15),
                    const SizedBox(height: 10),
                    const Text('Please check your internet connection.'),
                  ],
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Get.offAll(() => const SplashScreen());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              )
            : AlertDialog(
                surfaceTintColor: Theme.of(
                  Get.context!,
                ).scaffoldBackgroundColor,
                backgroundColor: Theme.of(Get.context!).cardColor,
                title: const Text(
                  'No Internet Connection',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(Images.noInternet, width: Get.height * 0.25),
                    const SizedBox(height: 12),
                    const Text('Please check your internet connection.'),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Get.offAll(() => const SplashScreen());
                    },
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
      barrierDismissible: false,
    );
  }

  void changeNumber(String number) {
    if (Platform.isIOS) {
      // iOS style dialog
      showCupertinoDialog(
        context: Get.context!,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text('Change Number'),
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(ctx),
              isDestructiveAction: true,
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              onPressed: () {
                getIt<OnboardingController>().numberController.clear();
                // Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    } else {
      // Android style dialog
      Get.dialog(
        AlertDialog(
          surfaceTintColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          backgroundColor: Theme.of(Get.context!).scaffoldBackgroundColor,
          content: Text('Are you sure you want to change\n+91 $number'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('No', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                getIt<OnboardingController>().numberController.clear();
                // Get.offAllNamed(Routes.login);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  void showConfirmationDialog(
    String title,
    String message, {
    required VoidCallback onConfirm,
  }) {
    Get.dialog(
      Dialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 50,
                color: Colors.redAccent,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: primaryBlack,
                ),
              ),
              SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: AppButton(
                      type: AppButtonType.text,
                      text: 'Cancel',
                      backgroundColor: Colors.transparent,
                      borderColor: Colors.transparent,
                      textColor: Colors.grey,
                      onTap: () {
                        Navigator.of(Get.context!).pop();
                      },
                    ),
                  ),
                  Expanded(
                    child: AppButton(
                      type: AppButtonType.secondary,
                      textColor: Colors.white,
                      text: 'Confirm',
                      backgroundColor: Colors.red,
                      onTap: onConfirm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
