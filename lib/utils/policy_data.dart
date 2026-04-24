import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../config/exported_path.dart';

class PolicyData extends StatefulWidget {
  final String slug;

  const PolicyData({super.key, required this.slug});

  @override
  State<PolicyData> createState() => _PolicyDataState();
}

class _PolicyDataState extends State<PolicyData> {
  final controller = getIt<ProfileController>();
  final language = getIt<LanguageController>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkInternetAndShowPopup();
      controller.getPolicy(
        slug: widget.slug.isEmpty
            ? language.isEnglish.value
                  ? 'about-us-english'
                  : 'about-us-marathi'
            : widget.slug,
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.isTrue
          ? Container(
              color: Colors.white,
              child: LoadingWidget(color: primaryColor),
            )
          : Scaffold(
              appBar: AppBar(
                surfaceTintColor: Colors.white,
                backgroundColor: Colors.white,
                titleSpacing: widget.slug.isEmpty ? 20 : 0,
                title: Text(
                  controller.privacyData['page_name'] ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              body: InAppWebView(
                initialUrlRequest: URLRequest(
                  url: WebUri('${controller.privacyData['url']}?key=demo'),
                ),
                initialSettings: InAppWebViewSettings(
                  pageZoom: 1.0,
                  supportZoom: true,
                  minimumFontSize: 8,
                  javaScriptEnabled: true,
                ),
                onLoadStart: (webController, url) {
                  controller.isLoading.value = true;
                },

                onLoadStop: (webController, url) async {
                  controller.isLoading.value = false;
                },
                onReceivedError: (_, __, ___) {
                  controller.isLoading.value = false;
                },
                onPermissionRequest: (controller, request) async {
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
              ),
            ),
    );
  }
}
