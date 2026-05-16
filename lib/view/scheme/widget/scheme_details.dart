import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:indapur_citizen/config/exported_path.dart';

class SchemeDetails extends StatefulWidget {
  final String slug;
  const SchemeDetails({super.key, required this.slug});

  @override
  State<SchemeDetails> createState() => _SchemeDetailsState();
}

class _SchemeDetailsState extends State<SchemeDetails> {
  final controller = getIt<SchemeController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getSchemeDetails(widget.slug);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isDetailsLoading.isTrue
          ? Container(
              color: Colors.white,
              child: LoadingWidget(color: primaryColor),
            )
          : Scaffold(
              backgroundColor: Colors.white,
              //     appBar: AppBar(
              //   title: Obx(() => Text(
              //     controller.name.isNotEmpty ? controller.name : 'Scheme Details',
              //     overflow: TextOverflow.ellipsis,
              //   )),
              //   backgroundColor: Colors.teal,
              // ),
              body: _buildHtmlView(),
            ),
    );
  }

  Widget _buildWebview() {
    return SafeArea(
      child: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri('${controller.schemeDetails['scheme_page']}'),
        ),
        initialSettings: InAppWebViewSettings(
          pageZoom: 1.0,
          supportZoom: true,
          minimumFontSize: 8,
          javaScriptEnabled: true,
        ),
        onLoadStart: (webController, url) {
          controller.isDetailsLoading.value = true;
        },

        onLoadStop: (webController, url) async {
          controller.isDetailsLoading.value = false;
        },
        onReceivedError: (_, __, ___) {
          controller.isDetailsLoading.value = false;
        },
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
      ),
    );
  }

  Widget _buildHtmlView() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey.withValues(alpha: 0.1),
        surfaceTintColor: Colors.grey.withValues(alpha: 0.1),
        title: Text(
          // controller.schemeDetails['name'].toString().isNotEmpty
          //     ? controller.schemeDetails['name'] ?? ''
          //     :
          'Scheme Details'.tr,
          style: TextStyle(
            color: Colors.black,
            fontSize: Get.width * 0.07,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isDetailsLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              SizedBox(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    controller.schemeDetails['image'] ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),

              // Name
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  controller.schemeDetails['name'] ?? '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff993e1f),
                  ),
                ),
              ),

              // Short Description Box
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xff993e1f).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Color(0xff993e1f), width: 0.5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xff993e1f),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.schemeDetails['short_description'] ?? '',
                          style: TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 10),

              // HTML Description
              Padding(
                padding: EdgeInsets.all(16),
                child: HtmlWidget(
                  // _formatHtml(controller.schemeDetails['description'] ?? ''),
                  controller.schemeDetails['description'] ?? '',
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // String _formatHtml(String html) {
  //   // Remove broken html tags
  //   html = html
  //       .replaceAll('<p><p>', '<p>')
  //       .replaceAll('</p></p>', '</p>')
  //       .replaceAll(RegExp(r'<p>\s*</p>'), '');
  //
  //   // Style every anchor tag dynamically
  //   html = html.replaceAllMapped(
  //     RegExp(r'<a([^>]*)>(.*?)</a>', caseSensitive: false),
  //     (match) {
  //       final attributes = match.group(1) ?? '';
  //       final text = match.group(2) ?? 'Open';
  //
  //       return '''
  //     <a $attributes
  //        style="
  //          background:#2196F3;
  //          color:white;
  //          padding:10px 18px;
  //          border-radius:8px;
  //          text-decoration:none;
  //          display:inline-block;
  //          margin-top:8px;
  //          font-weight:bold;">
  //        $text
  //     </a>
  //     ''';
  //     },
  //   );
  //
  //   return html;
  // }
}
