import 'package:indapur_citizen/config/exported_path.dart';

class OnboardingPage extends StatelessWidget {
  final String description;
  final String title;
  final String image;
  final VoidCallback onNextPressed;

  const OnboardingPage({
    super.key,
    required this.description,
    required this.title,
    required this.image,
    required this.onNextPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: const [0.1, 0.9],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [pageviewColor.withValues(alpha: .3), Colors.white],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset(image, width: Get.width * 0.8)),
            SizedBox(height: Get.height * 0.05),

            Text(
              title.tr,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: pageviewColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                description.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
