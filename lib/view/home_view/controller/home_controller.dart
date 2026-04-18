import 'dart:io';

import 'package:indapur_citizen/config/check_update.dart';
import 'package:indapur_citizen/config/exported_path.dart';
import 'package:ui_package/ui_package.dart';

@lazySingleton
class HomeController extends GetxController {
  final language = getIt<LanguageController>();
  final isLoading = true.obs;
  final name = ''.obs;
  final data = {}.obs;
  final departmentList = [].obs;
  final sliderList = [].obs;
  final complaintList = [].obs;
  final linksList = [].obs;
  final wardList = [].obs;
  final typeList = [].obs;
  final videoUrl = ''.obs;
  final pdf = ''.obs;
  final versionData = {}.obs;
  final currentVersion = ''.obs;
  final latestVersion = ''.obs;
  RxList filteredDataList = [].obs;
  final isSearch = false.obs;
  final searchController = TextEditingController();
  final isMainLoading = false.obs;

  void filterData(String query) {
    if (query.trim().isEmpty) {
      filteredDataList.assignAll(departmentList);
      return;
    }

    final lowerCaseQuery = query.toLowerCase().trim();

    filteredDataList.assignAll(
      departmentList.where((item) {
        final title = (item['name'] ?? '').toString().toLowerCase();
        return title.contains(lowerCaseQuery);
      }).toList(),
    );
  }

  Future<void> getHome() async {
    try {
      isMainLoading(true);
      final user = await LocalStorage.getString('user_id');
      final res = await apiClient.post(Urls.getHome, {
        'user_id': user,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      });

      final isSuccess = res['common']?['status'] == true;
      final data = res['data'] ?? {};

      if (isSuccess) {
        sliderList.value = data['sliders'] ?? [];
        departmentList.value = data['departments'] ?? [];
        complaintList.value = data['complaints'] ?? [];
        linksList.value = data['links'] ?? [];
        videoUrl.value = res['common']['video_url'] ?? '';
        pdf.value = res['common']['user_manual'];
        handleUpdate(Platform.isAndroid ? res['android'] : res['ios']);
        if (Platform.isAndroid) {
          if (res['android']['is_maintenance'] == true) {
            Get.offAll(
              () => Maintenance(msg: res['android']['maintenance_msg'] ?? ''),
              transition: Transition.rightToLeftWithFade,
            );
          }
        } else if (Platform.isIOS) {
          if (res['ios']['is_maintenance'] == true) {
            Get.offAll(
              () => Maintenance(msg: res['ios']['maintenance_msg'] ?? ''),
              transition: Transition.rightToLeftWithFade,
            );
          }
        }
      } else {
        _clearHomeData();
      }
      await checkLogin(res['user_login'] ?? true);
    } finally {
      isMainLoading(false);
    }
  }

  /// Clears all home screen lists
  void _clearHomeData() {
    sliderList.value = [];
    departmentList.value = [];
    complaintList.value = [];
    linksList.value = [];
  }

  // Future getDepartment() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var user = prefs.getString('user_id');
  //   final res = await apiClient.post(Urls.getDepartment, {
  //     'user_id': user,
  //     'lang': language.isEnglish.value ? 'en' : 'mr',
  //   });
  //
  //   checkLogin(res['user_login']);
  //   prefs.setString('manual', res['common']['user_manual']);
  //   res['common']['status'] == true
  //       ? departmentList.value = res['data']
  //       : departmentList.value = [];
  //   res['common']['status'] == true
  //       ? videoUrl.value = res['common']['video_url']
  //       : videoUrl.value = '';
  //   res['common']['status'] == true
  //       ? pdf.value = res['common']['user_manual']
  //       : pdf.value = '';
  //   res['common']['status'] == true
  //       ? versionData.value = res['android']
  //       : versionData.value = {};
  // }

  // Future getSlider() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   var user = prefs.getString('user_id');
  //   final res = await apiClient.post(Urls.getSlider, {'user_id': user});
  //   res['common']['status'] == true
  //       ? sliderList.value = res['data']
  //       : sliderList.value = [];
  //   // checkLogin(res['user_login']);
  // }

  // Future getComplaints() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     var user = prefs.getString('user_id');
  //     final res = await apiClient.post(Urls.getComplaint, {
  //       'user_id': user,
  //       'lang': language.isEnglish.value ? 'en' : 'mr',
  //     });
  //
  //     res['common']['status'] == true
  //         ? complaintList.value = res['data']
  //         : complaintList.value = [];
  //
  //     // checkLogin(res['user_login']);
  //   } finally {}
  // }

  Future getWard() async {
    try {
      final user = await LocalStorage.getString('user_id');
      final res = await apiClient.post(Urls.getWard, {
        'user_id': user,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      });
      res['common']['status'] == true
          ? wardList.value = res['data']
          : wardList.value = [];
    } catch (_) {}
  }

  Future getComplaintType(String deptId) async {
    try {
      final user = await LocalStorage.getString('user_id');
      final res = await apiClient.post(Urls.getComplaintType, {
        'user_id': user,
        'department_id': deptId,
        'lang': language.isEnglish.value ? 'en' : 'mr',
      });
      res['common']['status'] == true
          ? typeList.value = res['data']
          : typeList.value = [];
    } catch (_) {}
  }
}
