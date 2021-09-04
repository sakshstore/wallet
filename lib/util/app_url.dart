class AppUrl {
  static const String liveBaseURL = "https://wapi.alphakoin.io/api/";
  static const String localBaseURL = "https://wapi.alphakoin.io/api/";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "auth/AuthToken";

  static const String updatepassword = baseURL + "auth/changepassword";

  static const String dashboard = baseURL + "v3/wallet/Dashboard";

  static const String register = baseURL + "RegisterAPI";

  static const String sendFund = baseURL + "wallet/sendFund";

  static const String balance = baseURL + "wallet/Balance";

  static const String forgotPassword = baseURL + "/forgot-password";



}
