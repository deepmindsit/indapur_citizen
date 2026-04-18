import 'package:indapur_citizen/config/exported_path.dart';
import 'package:ui_package/ui_package.dart';

@lazySingleton
class ComplaintController extends GetxController {
  final isFirstLoadRunning = false.obs;
  final isLoadMoreRunning = false.obs;
  RxInt page = 0.obs;
  final hasNextPage = false.obs;
  final language = getIt<LanguageController>();
  final complaintList = [].obs;

  Future firstLoad() async {
    final limit = 10;

    try {
      isFirstLoadRunning.value = true;
      page.value = 0;
      var user = await LocalStorage.getString('user_id');
      final res = await apiClient.post(Urls.getComplaint, {
        'user_id': user,
        'lang': language.isEnglish.value ? 'en' : 'mr',
        'page_no': page.toString(),
      });
      checkLogin(res['user_login']);
      complaintList.value = res['data'];
      hasNextPage.value = complaintList.length == limit;
    } finally {
      isFirstLoadRunning.value = false;
    }
  }

  void loadMore() async {
    if (hasNextPage.value == true &&
        isFirstLoadRunning.value == false &&
        isLoadMoreRunning.value == false) {
      isLoadMoreRunning.value = true;
      page.value += 1;
      try {
        var user = await LocalStorage.getString('user_id');
        final res = await apiClient.post(Urls.getComplaint, {
          'user_id': user,
          'lang': language.isEnglish.value ? 'en' : 'mr',
          'page_no': page.toString(),
        });
        final List fetchedPosts = res['data'] ?? [];
        if (fetchedPosts.isNotEmpty) {
          complaintList.addAll(fetchedPosts);
        } else {
          hasNextPage.value = false;
        }
      } catch (_) {
      } finally {
        isLoadMoreRunning.value = false;
      }
    }
  }
}
