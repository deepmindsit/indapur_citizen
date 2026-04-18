import 'package:indapur_citizen/config/exported_path.dart';
import 'package:ui_package/ui_package.dart';

@lazySingleton
class GetLinks extends GetxController {
  final linkList = [].obs;
  final isLoading = true.obs;
  final language = getIt<LanguageController>();

  Future<void> getLinks() async {
    try {
      isLoading(true);
      var user = await LocalStorage.getString('user_id');
      final res = await apiClient.post(Urls.getLinks, {
        'user_id': user,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      });

      await checkLogin(res['user_login']);
      res['common']['status'] == true
          ? linkList.value = res['data']
          : linkList.value = [];
    } finally {
      isLoading(false);
    }
  }
}
