import '../../../config/exported_path.dart';

@lazySingleton
class BottomNavigationPageController extends GetxController {
  static BottomNavigationPageController get to => Get.find();

  final currentIndex = 0.obs;

  List<Widget> pages = [
    const HomeScreen(),

    const AboutUs(),
    const ComplaintTest(),
    const Links(),
    const Profile(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
