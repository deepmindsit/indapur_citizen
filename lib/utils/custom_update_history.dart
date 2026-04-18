import 'dart:io';
import '../config/exported_path.dart';

class UpdateHistoryList extends StatelessWidget {
  final List updateRecords;

  const UpdateHistoryList({super.key, required this.updateRecords});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...updateRecords.map(
          (record) => Container(
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Row
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey.shade300,
                      child: ClipOval(
                        child: FadeInImage(
                          placeholder: AssetImage(Images.logo),
                          image: NetworkImage(record['profile_image'] ?? ''),
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              Images.logo,
                              width: 36,
                              height: 36,
                              fit: BoxFit.contain,
                            );
                          },
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${record['updated_by'] ?? ''} (${record['comment_person_role'] ?? ''})',
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            record['created_on'] ?? '',
                            maxLines: 2,
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (record['status'] != null)
                      StatusBadge(
                        status: record['status'] ?? '',
                        color:
                            int.tryParse(
                              record['status_color']?.toString() ?? '',
                            ) ??
                            0xFF898989,
                      ),
                  ],
                ),

                // Remark Box
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: HtmlWidget(record['description'] ?? ''),
                ),

                // Attachments
                if (record['attachments']?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Attachments :',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  attachment(record),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget attachment(record) {
    final attachments = record['attachments'] ?? [];
    if (attachments.isEmpty) {
      return SizedBox();
    }
    return SizedBox(
      height: Get.height * 0.18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          final String path = attachments[index] ?? '';

          /// 🔹 Safe name extract
          final name = path.split('/').last;

          /// 🔹 Extension
          final extension = name.split('.').last.toLowerCase();
          final isImage = [
            'jpg',
            'jpeg',
            'png',
            'gif',
            'webp',
          ].contains(extension);
          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: Container(
              width: Get.width * 0.45,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File Preview Section
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      if (isImage)
                        WidgetZoom(
                          heroAnimationTag: 'tag $path',
                          zoomWidget: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              path,
                              height: 80,
                              width: double.infinity,
                              fit: BoxFit.contain,
                              loadingBuilder: (_, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return SizedBox(
                                  height: 80,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox(
                                  height: 80,
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      else
                        Container(
                          height: 80,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: getFileTypeColor(extension),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Icon(
                            getIconForFile(name),
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withValues(alpha: 0.6),
                          child: InkWell(
                            onTap: () => downloadFile(path),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.download,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2),
                  Text(
                    name.length > 20 ? '${name.substring(0, 19)}...' : name,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> downloadFile(String url) async {
    final fileName = Uri.parse(url).pathSegments.last;
    Get.snackbar(
      'Download Start',
      'Starting download for "$fileName"...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.white,
      colorText: Colors.black,
    );
    // showToastNormal('Starting download for "$fileName"...');

    // Start file download
    FileDownloader.downloadFile(
      url: url,
      name: fileName,
      onDownloadCompleted: (String filePath) async {
        final file = File(filePath);
        // Try to open the downloaded file
        await OpenFilex.open(file.path);
      },
      onDownloadError: (String errorMessage) {
        // Notify user about download failure
        Get.snackbar(
          'Download Failed',
          'Could not download "$fileName". Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: Colors.black,
        );
      },
    );
  }
}
