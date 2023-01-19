class Details {
  String trnNo;
  String shopName;
  String ownerName;
  String mobileNumber;
  String place;
  String address;
  String pincode;
  String email;
  String password;
  Details(
      {this.address = "",
      this.email = "",
      this.mobileNumber = "",
      this.ownerName = "",
      this.password = "",
      this.pincode = "",
      this.place = "",
      this.shopName = "",
      this.trnNo = ""});

  Map<String, dynamic> toJson() {
    return {
      "shop_name": shopName,
      "owner_name": ownerName,
      "mobile": mobileNumber,
      "password": password,
      "email": email,
      "address": address,
      "place": place,
      "pincode": pincode,
      "trn": trnNo,
    };
  }
}
