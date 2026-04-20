import 'package:indapur_citizen/config/exported_path.dart';
import 'package:ui_package/ui_package.dart';

class Signup extends StatefulWidget {
  final String number;

  const Signup({super.key, required this.number});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final nameController = TextEditingController();
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  dynamic data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        // surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    Images.logoVert,
                    height: Get.height * 0.25,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Sign Up'.tr,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Text(
                  'Please Enter your Details to proceed Further'.tr,
                  style: TextStyle(fontSize: 16, color: primaryGrey),
                ),
                SizedBox(height: Get.height * 0.01),
                Text(
                  'Name'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                TextFormField(
                  controller: nameController,
                  validator: (value) => nameValidator(value!),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    // labelText: 'Description',
                    hintText: 'Name'.tr,
                    labelText: 'Name'.tr,
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Text(
                  'OTP'.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                _buildOTPField('Enter OTP'),
                SizedBox(height: Get.height * 0.01),
                _buildRegisterButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ---------------- OTP FIELD ----------------
  Widget _buildOTPField(String label) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(
        fontSize: 22,
        color: Theme.of(context).textTheme.bodySmall!.color,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).textTheme.bodySmall!.color!,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppLabel(text: label),
        SizedBox(height: 8),
        Center(
          child: Pinput(
            controller: otpController,
            length: 6,
            keyboardType: TextInputType.number,
            validator: (value) =>
                value == null || value.isEmpty ? 'OTP is required' : null,
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: primaryColor, width: 2),
              ),
            ),
            submittedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: primaryColor),
              ),
            ),
            onCompleted: (pin) {},
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 11),
      child: AppButton(
        text: 'Submit',
        onTap: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return FutureBuilder(
                  builder:
                      (
                        BuildContext context,
                        AsyncSnapshot<Map<String, dynamic>> snapshot,
                      ) {
                        List<Widget> children;
                        if (snapshot.hasData) {
                          data = snapshot.data;
                          if (data!['common']['status'] == true) {
                            Future.delayed(
                              const Duration(seconds: 2),
                              () async {
                                var prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString(
                                  'auth_key',
                                  data['user']['auth_key'],
                                );
                                prefs.setString(
                                  'user_id',
                                  data['user']['id'].toString(),
                                );
                                prefs.setString(
                                  'manual',
                                  data['common']['user_manual'],
                                );
                                prefs.setString(
                                  'user_name',
                                  data['user']['name'],
                                );
                                prefs.setString(
                                  'userDetails',
                                  json.encode(data['user']),
                                );
                                Get.offAll(() => MainScreen());
                              },
                            );

                            children = <Widget>[
                              const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                                size: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  data['common']['message'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ];
                          } else {
                            Future.delayed(const Duration(seconds: 2), () {
                              Get.back();
                            });
                            children = <Widget>[
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 60,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  data['common']['message'],
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ];
                          }
                        } else {
                          Future.delayed(const Duration(seconds: 5), () {
                            // Get.back();
                          });

                          children = <Widget>[
                            const SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                'Processing'.tr,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ];
                        }
                        return AlertDialog(
                          surfaceTintColor: Colors.white,
                          backgroundColor: Colors.white,
                          content: SizedBox(
                            height: 150,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: children,
                              ),
                            ),
                          ),
                        );
                      },
                  future: OnboardingController().register(
                    otp: otpController.text.trim(),
                    mobileNo: widget.number,
                    name: nameController.text,
                  ),
                );
              },
            );
          } else {
            Get.snackbar('Error', 'ERROR');
          }
        },
        backgroundColor: pageviewColor.withValues(alpha: 0.8),
      ),

      // ElevatedButton(
      //   style: ButtonStyle(
      //     backgroundColor: WidgetStateProperty.all(primaryColor),
      //     minimumSize: WidgetStateProperty.all(const Size(double.infinity, 40)),
      //   ),
      //   onPressed: () async {
      //     final isValid = _formKey.currentState!.validate();
      //     if (isValid) {
      //       showDialog(
      //         barrierDismissible: false,
      //         context: context,
      //         builder: (BuildContext context) {
      //           return FutureBuilder(
      //             builder:
      //                 (
      //                   BuildContext context,
      //                   AsyncSnapshot<Map<String, dynamic>> snapshot,
      //                 ) {
      //                   List<Widget> children;
      //                   if (snapshot.hasData) {
      //                     data = snapshot.data;
      //                     if (data!['common']['status'] == true) {
      //                       Future.delayed(
      //                         const Duration(seconds: 2),
      //                         () async {
      //                           var prefs =
      //                               await SharedPreferences.getInstance();
      //                           prefs.setString(
      //                             'auth_key',
      //                             data['user']['auth_key'],
      //                           );
      //                           prefs.setString(
      //                             'user_id',
      //                             data['user']['id'].toString(),
      //                           );
      //                           prefs.setString(
      //                             'manual',
      //                             data['common']['user_manual'],
      //                           );
      //                           prefs.setString(
      //                             'user_name',
      //                             data['user']['name'],
      //                           );
      //                           prefs.setString(
      //                             'userDetails',
      //                             json.encode(data['user']),
      //                           );
      //                           Get.offAll(() => MainScreen());
      //                         },
      //                       );
      //
      //                       children = <Widget>[
      //                         const Icon(
      //                           Icons.check_circle_outline,
      //                           color: Colors.green,
      //                           size: 60,
      //                         ),
      //                         Padding(
      //                           padding: const EdgeInsets.only(top: 16),
      //                           child: Text(
      //                             data['common']['message'],
      //                             style: const TextStyle(color: Colors.black),
      //                           ),
      //                         ),
      //                       ];
      //                     } else {
      //                       Future.delayed(const Duration(seconds: 2), () {
      //                         Get.back();
      //                       });
      //                       children = <Widget>[
      //                         const Icon(
      //                           Icons.error_outline,
      //                           color: Colors.red,
      //                           size: 60,
      //                         ),
      //                         Padding(
      //                           padding: const EdgeInsets.only(top: 16),
      //                           child: Text(
      //                             data['common']['message'],
      //                             style: const TextStyle(color: Colors.black),
      //                           ),
      //                         ),
      //                       ];
      //                     }
      //                   } else {
      //                     Future.delayed(const Duration(seconds: 5), () {
      //                       // Get.back();
      //                     });
      //
      //                     children = <Widget>[
      //                       const SizedBox(
      //                         width: 60,
      //                         height: 60,
      //                         child: CircularProgressIndicator(),
      //                       ),
      //                       Padding(
      //                         padding: const EdgeInsets.only(top: 16),
      //                         child: Text(
      //                           'Processing'.tr,
      //                           style: const TextStyle(color: Colors.black),
      //                         ),
      //                       ),
      //                     ];
      //                   }
      //                   return AlertDialog(
      //                     surfaceTintColor: Colors.white,
      //                     backgroundColor: Colors.white,
      //                     content: SizedBox(
      //                       height: 150,
      //                       child: Center(
      //                         child: Column(
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           children: children,
      //                         ),
      //                       ),
      //                     ),
      //                   );
      //                 },
      //             future: OnboardingController().register(
      //               otp: otpController.text.trim(),
      //               mobileNo: widget.number,
      //               name: nameController.text,
      //             ),
      //           );
      //         },
      //       );
      //     } else {
      //       Get.snackbar('Error', 'ERROR');
      //     }
      //   },
      //   child: Text('Submit'.tr, style: const TextStyle(fontSize: 18)),
      // ),
    );
  }
}
