import 'package:indapur_citizen/config/exported_path.dart';
import 'package:ui_package/ui_package.dart';

@lazySingleton
class SplashController extends GetxController {
  final token = ''.obs;
  final expanded = false.obs;
  final isOnboarded = false.obs;
  final transitionDuration = const Duration(seconds: 1);

  Future<void> initialize() async {
    await _loadPreferences();
    await Future.delayed(transitionDuration);
    expanded.value = true;
    await Future.delayed(transitionDuration);

    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    if (!connectivityResult.contains(ConnectivityResult.none)) {
      token.value.isNotEmpty
          ? Get.offAll(() => MainScreen())
          : Get.offAll(() => const PageViewWidget());
    } else {
      AllDialogs().noInternetDialog();
    }
  }

  Future<void> _loadPreferences() async {
    token.value = await LocalStorage.getString('auth_key') ?? '';
  }
}
