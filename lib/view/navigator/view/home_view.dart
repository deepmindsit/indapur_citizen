import '../../../config/exported_path.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final bottomNavigationPageController = Get.put(
    BottomNavigationPageController(),
  );

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: BottomNavigationPageController.to.currentPage,
        bottomNavigationBar: Theme(
          data: ThemeData(useMaterial3: false, splashColor: Colors.transparent),
          child: BottomNavigationBar(
            unselectedFontSize: 11,
            elevation: 10,
            backgroundColor: Colors.white,
            currentIndex: BottomNavigationPageController.to.currentIndex.value,
            onTap: BottomNavigationPageController.to.changePage,
            unselectedItemColor: Colors.grey,
            selectedItemColor: primaryOrange,
            showUnselectedLabels: true,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: HugeIcon(icon: HugeIcons.strokeRoundedHome01),
                label: 'Home'.tr,
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedInformationCircle,
                ),
                label: 'About Us2'.tr,
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedUserWarning01,
                ),
                label: 'Complaints'.tr,
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: const HugeIcon(icon: HugeIcons.strokeRoundedLink02),
                label: 'Links'.tr,
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: const HugeIcon(icon: HugeIcons.strokeRoundedUser),
                label: 'Profile'.tr,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
