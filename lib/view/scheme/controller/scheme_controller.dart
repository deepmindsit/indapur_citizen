import 'package:indapur_citizen/config/exported_path.dart';
import 'package:ui_package/ui_package.dart';

@lazySingleton
class SchemeController extends GetxController {
  final schemeList = [].obs;
  final schemeDetails = {}.obs;
  final isLoading = true.obs;
  final isDetailsLoading = true.obs;
  final language = getIt<LanguageController>();

  Future<void> getSchemeList() async {
    try {
      isLoading(true);
      var user = await LocalStorage.getString('user_id');
      final res = await apiClient.post(Urls.getScheme, {
        'user_id': user,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      });

      await checkLogin(res['user_login']);
      res['common']['status'] == true
          ? schemeList.value = res['data']
          : schemeList.value = [];
    } finally {
      isLoading(false);
    }
  }

  Future<void> getSchemeDetails(String slug) async {
    try {
      isDetailsLoading(true);
      var user = await LocalStorage.getString('user_id');
      final res = await apiClient.post(Urls.getSchemeDetails, {
        'user_id': user,
        'lang': language.isEnglish.value ? 'en' : 'mr',
        'slug': slug,
      });

      await checkLogin(res['user_login']);
      res['common']['status'] == true
          ? schemeDetails.value = res['data']
          : schemeDetails.value = {};
    } finally {
      isDetailsLoading(false);
    }
  }
}
