import 'package:indapur_citizen/config/exported_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final controller = getIt<SplashController>();

  @override
  void initState() {
    super.initState();
    controller.initialize();
  }

  //
  // String? token;
  // var expanded = false;
  // bool? isOnboarded;
  // final transitionDuration = const Duration(seconds: 1);
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _initialize();
  // }
  //
  // Future<void> _initialize() async {
  //   await _loadPreferences();
  //   Future.delayed(
  //     const Duration(seconds: 1),
  //   ).then((value) => setState(() => expanded = true));
  //   final connectivityResult = await (Connectivity().checkConnectivity());
  //
  //   if (!connectivityResult.contains(ConnectivityResult.none)) {
  //     token != null
  //         ? Get.offAll(() => MainScreen())
  //         : Get.offAll(() => const PageViewWidget());
  //   } else {
  //     AllDialogs().noInternetDialog();
  //   }
  // }
  //
  // Future<void> _loadPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   token = prefs.getString('auth_key');
  //   isOnboarded = prefs.getBool('isOnboarded');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
            /// Full Screen Background Image
            Positioned.fill(
              child: Image.asset(
                Images.splashScreen,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );


    //   Material(
    //   surfaceTintColor: Colors.white,
    //   color: Colors.white,
    //   child: Container(
    //     color: Colors.white,
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Obx(
    //           () => AnimatedCrossFade(
    //             firstCurve: Curves.fastOutSlowIn,
    //             crossFadeState: !controller.expanded.value
    //                 ? CrossFadeState.showFirst
    //                 : CrossFadeState.showSecond,
    //             duration: controller.transitionDuration,
    //             firstChild: Container(),
    //             secondChild: _logoRemainder(),
    //             alignment: Alignment.centerLeft,
    //             sizeCurve: Curves.easeInOut,
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }

  // Widget _logoRemainder() {
  //   return Image.asset(Images.logo, width: Get.width * 0.7);
  // }
}
