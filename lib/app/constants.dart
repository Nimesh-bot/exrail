class Constant {
  // static const String baseURL = "http://10.0.2.2:8000/api/";
  // static const String baseURL = "http://localhost:8000/api/";

  // ----------------IP URL----------------
  static const String baseURL = "http://192.168.1.74:8000/api/";

  // ----------------User URL----------------
  static const String userLoginUrl = "auth/login";
  static const String userRegisterURL = "auth/register";
  static const String userPasswordResetUrl = "auth/passwordReset";
  static const String userVerifyPasswordResetUrl = "auth/verify/reset";
  static const String userUpdatePasswordUrl = "auth/newPassword";
  static const String userByEmailUrl = "user/";
  static const String userDetailUrl = "user";
  static const String userAdditionalIncomeUrl = "user/additional";
  static const String userUpdateImageUrl = "user/profile_image";
  static const String userUpdateNameUrl = "user/info";

  // ----------------Expenses URL----------------
  static const String userExpensesUrl = "expenses/defexpense";
  static const String userUpdateExpensesUrl = "expenses/";
  static const String userUpdateEstimatedExpensesUrl = "expenses/estimated/";

  // ----------------Income URL----------------
  static const String userIncomeUrl = "income";
  static const String userAddIncomeFirstTimeUrl = "user/income";

  // ----------------Wish URL----------------
  static const String userWishUrl = "wish/";

  // For storing token in constant variable
  static String token = "";
}
