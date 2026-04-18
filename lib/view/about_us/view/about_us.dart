import 'package:indapur_citizen/config/exported_path.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final controller = getIt<GetAbout>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getAbout();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => controller.isLoading.isTrue
              ? LoadingWidget(color: primaryBlack)
              : controller.aboutList.isNotEmpty
              ? aboutUsContent()
              : Center(
                  child: CustomText(title: 'No Data Found'.tr, fontSize: 14),
                ),
        ),
      ),
    );
  }

  Widget aboutUsContent() {
    final aboutData = controller.aboutList;
    return AnimationLimiter(
      child: ListView(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 375),
          childAnimationBuilder: (widget) => SlideAnimation(
            verticalOffset: 50,
            // horizontalOffset: 50.0,
            child: FadeInAnimation(child: widget),
          ),
          children: [
            Column(
              children: [
                Column(
                  spacing: Get.height * 0.015,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      aboutData['title'] ?? '',
                      style: TextStyle(
                        fontSize: Get.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FadeInImage(
                      placeholder: AssetImage(Images.aboutUs),
                      imageErrorBuilder: (context, error, _) =>
                          Image.asset(Images.aboutUs),
                      image: NetworkImage(aboutData['image'] ?? ''),
                    ),
                    const Divider(),
                    Text(
                      aboutData['description'] ?? '',
                      style: TextStyle(
                        fontSize: Get.width * 0.04,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
      title: Text(
        'About Us'.tr,
        style: TextStyle(
          color: Colors.black,
          fontSize: Get.width * 0.07,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
