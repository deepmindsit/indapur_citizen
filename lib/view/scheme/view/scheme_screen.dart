import 'package:indapur_citizen/config/exported_path.dart';
import 'package:indapur_citizen/view/scheme/widget/scheme_details.dart';

class SchemeScreen extends StatefulWidget {
  const SchemeScreen({super.key});

  @override
  State<SchemeScreen> createState() => _SchemeScreenState();
}

class _SchemeScreenState extends State<SchemeScreen> {
  final controller = getIt<SchemeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    controller.getSchemeList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
        title: Text(
          'Scheme'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: Get.width * 0.07,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return LoadingWidget(color: primaryBlack);
        }

        if (controller.schemeList.isEmpty) {
          return const Center(child: Text('Data Not Found'));
        }

        return schemeData();
      }),
    );
  }

  Widget schemeData() {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 5.0,
          mainAxisExtent: Get.height * 0.16,
          crossAxisSpacing: 5.0, // spacing between columns
        ),
        itemCount: controller.schemeList.length,
        itemBuilder: (_, int index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: controller.schemeList.length,
            child: ScaleAnimation(
              child: FadeInAnimation(child: buildLinkCard(index)),
            ),
          );
        },
      ),
    );
  }

  Widget buildLinkCard(int index) {
    final link = controller.schemeList[index];
    return GestureDetector(
      onTap: () => Get.to(() => SchemeDetails(slug: link['slug'] ?? '')),
      // link['url'] != null ? launchInBrowser(Uri.parse(link['url'])) : null,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: linkContent(link),
      ),
    );
  }

  Widget linkContent(var link) {
    return Container(
      width: Get.width * 0.3,
      height: Get.width * 0.2,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: const Offset(2, 2),
            color: Colors.grey.shade300,
            blurRadius: 5.0,
          ),
        ],
        color: Colors.white,
        border: Border.all(width: 0.5, color: Colors.black54),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              link['image'],
              height: Get.height * 0.07,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
          ),
          Text(
            link['name'] ?? '',
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: const TextStyle(height: 1),
          ),
        ],
      ),
    );
  }
}
