class Urls {
  Urls._();

  // static const String _baseURL = "http://192.168.29.37/myindapurnp/api/v1";
  // static const String _baseURL = "https://myindapurnp.diabot.in/api/v1";
  // static const String _baseURL = "https://beta.indapurnp.in/api/v1";
  static const String _baseURL = "https://indapurnp.in/api/v1";
  static String sendOtp = "$_baseURL/send-otp";
  static String register = "$_baseURL/register";
  static String verifyOtp = "$_baseURL/verify-otp";
  static String updateProfile = "$_baseURL/update";
  static String deleteAccount = "$_baseURL/delete-account";
  static String aboutUS = "$_baseURL/get-about-us";
  static String getHome = "$_baseURL/get-home";
  static String newComplaint = "$_baseURL/complaint";
  static String getComplaint = "$_baseURL/get-complaint";
  static String getComplaintDetails = "$_baseURL/get-complaint-details";
  static String getNotification = "$_baseURL/get-notification";
  static String readNotification = "$_baseURL/read-notification";
  static String getDepartment = "$_baseURL/get-department";
  static String getSlider = "$_baseURL/get-slider";
  static String getWard = "$_baseURL/get-ward";
  static String getComplaintType = "$_baseURL/get-complaint-type";
  static String getLinks = "$_baseURL/get-link";
  static String updateFirebaseToken = "$_baseURL/update-firebase-token";
  static String legalPage = "$_baseURL/get-legal-page";
}
