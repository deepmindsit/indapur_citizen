import 'package:indapur_citizen/config/exported_path.dart';

class ComplaintTest extends StatefulWidget {
  const ComplaintTest({super.key});

  @override
  State<ComplaintTest> createState() => _ComplaintTestState();
}

class _ComplaintTestState extends State<ComplaintTest> {
  final controller = getIt<ComplaintController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    controller.firstLoad();
    super.initState();
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
          'Complaints'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: Get.width * 0.07,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(
        () => NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollEndNotification &&
                scrollNotification.metrics.pixels ==
                    scrollNotification.metrics.maxScrollExtent) {
              controller.loadMore();
            }
            return true;
          },
          child: controller.isFirstLoadRunning.isTrue
              ? LoadingWidget(color: primaryBlack)
              : controller.complaintList.isEmpty
              ? emptyComplaint()
              : Column(
                  children: [
                    Expanded(child: complaintList()),
                    buildLoader(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget complaintList() {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: controller.complaintList.length,
        itemBuilder: (_, index) => AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(child: complaintCard(index)),
          ),
        ),
      ),
    );
  }

  Widget complaintCard(int index) {
    final complaint = controller.complaintList[index];
    final int statusColor =
        int.tryParse(complaint['status_color'] ?? '0xFF000000') ?? 0xFF000000;
    return GestureDetector(
      onTap: () => Get.to(
        () => ComplaintSummary(
          isList: true,
          complaintId: complaint['id'].toString(),
        ),
      ),
      child: ComplaintCard(
        title: complaint['department'] ?? 'N/A',
        location: complaint['complaint_type']?.toString() ?? 'N/A',
        date: complaint['created_on_date'] ?? 'N/A',
        status: complaint['status'] ?? 'N/A',
        statusColor: statusColor.toString(),
        ticketNo: complaint['code'] ?? '',
        deptImg: complaint['department_image'],
      ),
    );
  }

  Widget buildLoader() {
    if (controller.isLoadMoreRunning.value) {
      return Padding(
        padding: EdgeInsets.all(8.0),
        child: LoadingWidget(color: primaryBlack),
      );
    } else if (!controller.hasNextPage.value) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(child: Text('No more data')),
      );
    }
    return const SizedBox.shrink();
  }

  Widget emptyComplaint() {
    return Center(
      child: SizedBox(
        width: Get.width * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(Images.noData),
            Text(
              'No Data Found'.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
