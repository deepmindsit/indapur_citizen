import 'package:indapur_citizen/config/exported_path.dart';

@lazySingleton
class DeleteAccountController {
  DeleteAccountController._privateConstructor();

  static final DeleteAccountController _instance =
      DeleteAccountController._privateConstructor();

  factory DeleteAccountController() {
    return _instance;
  }

  Future<Map<String, dynamic>> deleteAccountData() async {
    final prefs = await SharedPreferences.getInstance();
    var user = prefs.getString('user_id');
    final res = await apiClient.post(
      Urls.deleteAccount,
      {
        'user_id': user,
      },
    );

    // var prefs = await SharedPreferences.getInstance();
    // var authKey = prefs.getString('auth_key');
    // var user = prefs.getString('user_id');
    // final url = Uri.parse(Urls.deleteAccount);
    // final response = await http.post(
    //   url,
    //   headers: {'Authorization': 'Bearer $authKey'},
    //   body: {
    //     'user_id': user,
    //   },
    // );
    // Map<String, dynamic> res =
    //     json.decode(response.body) as Map<String, dynamic>;

    return res;
  }
}
