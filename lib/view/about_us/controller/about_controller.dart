import 'package:ui_package/ui_package.dart';

import '../../../config/exported_path.dart';

@lazySingleton
class GetAbout extends GetxController {
  final aboutList = {}.obs;
  var isLoading = true.obs;
  final language = getIt<LanguageController>();

  void getAbout() async {
    try {
      isLoading(true);
      var userId = await LocalStorage.getString('user_id');
      final res = await apiClient.post(Urls.aboutUS, {
        'user_id': userId,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      });
      checkLogin(res['user_login']);
      aboutList.value = res['common']['status'] == true ? res['data'][0] : [];
    } finally {
      isLoading(false);
    }
  }
}
