class LoginModal {
  String mobileNumber;
  String password;
  LoginModal({required this.mobileNumber, required this.password});

  Map<String, dynamic> toJson() {
    return {
      "mobile": mobileNumber,
      "password": password,
    };
  }
}
