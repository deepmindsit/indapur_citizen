import 'package:indapur_citizen/config/exported_path.dart';

class ComplaintSummary extends StatefulWidget {
  final String complaintId;
  final bool isList;

  const ComplaintSummary({
    super.key,
    required this.complaintId,
    required this.isList,
  });

  @override
  State<ComplaintSummary> createState() => _ComplaintSummaryState();
}

class _ComplaintSummaryState extends State<ComplaintSummary> {
  final controller = getIt<GetSummary>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
    });
    controller.getSummary(complaintId: widget.complaintId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        if (context.mounted) Get.offAll(() => MainScreen());
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),
        appBar: AppBar(
          titleSpacing: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              widget.isList ? Get.back() : Get.offAll(() => MainScreen());
            },
          ),
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xFFF4F6FA),
          surfaceTintColor: const Color(0xFFF4F6FA),
          title: Text(
            'Complaint Summary'.tr,
            style: TextStyle(
              color: Colors.black,
              fontSize: Get.width * 0.07,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => controller.isLoading.isTrue
                ? LoadingWidget(color: primaryBlack)
                : controller.summaryList.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (!widget.isList) _buildHeaderSection(),
                        if (!widget.isList) _buildTitle('SUMMARY'.tr),
                        _buildTitleCard(),
                        SizedBox(height: 12),
                        _buildDescriptionCard(),
                        SizedBox(height: 12),
                        if (controller.summaryList['attachments'] != null &&
                            (controller.summaryList['attachments'] as List)
                                .isNotEmpty)
                          _buildAttachmentsSection(),
                        _buildUpdatesSection(),
                      ],
                    ),
                  )
                : Center(
                    child: CustomText(title: 'No Data Found'.tr, fontSize: 14),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCard() {
    return GlassCard(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            sectionTitleWithIcon('📄 ${controller.summaryList['code'] ?? ''}'),
            StatusBadge(
              status: controller.summaryList['status'] ?? '',
              color:
                  int.tryParse(controller.summaryList['status_color'] ?? '') ??
                  0xFF025599,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: buildDetailRow(
                icon: HugeIcons.strokeRoundedUser,
                title: 'Created By'.tr,
                value: controller.userData['name'] ?? '',
              ),
            ),

            Expanded(
              child: buildDetailRow(
                icon: HugeIcons.strokeRoundedUser,
                title: 'Date & Time :'.tr,
                value: controller.summaryList['created_on_date'] ?? '',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildDetailRow(
                icon: HugeIcons.strokeRoundedOffice,
                title: 'Department :'.tr,
                value: controller.summaryList['department'] ?? '-',
              ),
            ),
            Expanded(
              child: buildDetailRow(
                icon: HugeIcons.strokeRoundedLocation09,
                title: 'Landmark :'.tr,
                value: controller.summaryList['landmark'].toString().isNotEmpty
                    ? controller.summaryList['landmark']?.toString() ?? '-'
                    : '-',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: buildDetailRow(
                icon: HugeIcons.strokeRoundedPinLocation02,
                title: 'ward'.tr,
                value: controller.summaryList['ward']?.toString() ?? '-',
              ),
            ),
            Expanded(
              child: buildDetailRow(
                icon: HugeIcons.strokeRoundedArrange,
                title: 'Complaint Type'.tr,
                value: controller.summaryList['complaint_type'] ?? '-',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return GlassCard(
      children: [
        Row(
          children: [
            IconBox(
              icon: HugeIcons.strokeRoundedDocumentValidation,
              size: 20,
              color: pageviewColor,
            ),
            SizedBox(width: 8),
            CustomText(
              title: 'Description :'.tr,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        SizedBox(height: 12),
        CustomText(
          title: controller.summaryList['description']?.toString() ?? '-',
          fontSize: 14,
          textAlign: TextAlign.start,
          maxLines: 12,
        ),
        _buildDescription(context),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    final description = controller.summaryList['description'] ?? '';

    if (description.length < 50) {
      return const SizedBox();
    }

    return GestureDetector(
      onTap: () {
        _showBottomSheet(context, description);
      },
      child: const Padding(
        padding: EdgeInsets.all(3.0),
        child: Text(
          'Read More',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return GlassCard(
      children: [
        sectionTitleWithIcon('📎${'Attachments :'.tr}'),
        AttachmentPreviewList(
          attachments: controller.summaryList['attachments'],
          onDownload: (path) => (),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        Center(
          child: Image.asset(
            'assets/images/tick_mark.gif',
            height: Get.height * 0.15,
          ),
        ),
        Text(
          'apology'.tr,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        const Divider(color: Colors.blue),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const Divider(color: Colors.blue),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context, String desc) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(desc),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUpdatesSection() {
    final comments = controller.summaryList['comments'] ?? [];
    if (comments.isEmpty) return SizedBox();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Updates History :'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 8),
          UpdateHistoryList(updateRecords: controller.summaryList['comments']),
        ],
      ),
    );
  }
}
