import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/verify_otp.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/forgot_password.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/widgets/loading_animation.dart';

class SubmitNumber extends StatelessWidget {
  final String number;
  const SubmitNumber({Key? key, required this.number}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: forgotPassword(number),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var result = snapshot.data;
            if (result["status"] == "not exist") {
              Fluttertoast.showToast(
                  msg: "Enter a registered Mobile number",
                  backgroundColor: Colors.red.shade800,
                  textColor: Colors.white);
              return ForgotPassword();
            } else {
              var otp = result["otp"];
              var shopId = result["shop_id"];
              return VerifyOtp(otp: otp.toString(), shopId: shopId.toString());
            }
          } else if (snapshot.hasError) {
            var error = snapshot.error;
            if (error == "Socket exception") {
              return const NoNetwork();
            } else {
              return const ErrorPage();
            }
          } else {
            return const LoadingAnimation();
          }
        },
      ),
    );
  }
}

//  if (snapshot.hasData) {
//             print(snapshot.data);
//             var result=snapshot.data;

//             if(result["status"]=="not exist"){
//               Fluttertoast.showToast(msg: "Enter a registered Mobile number",backgroundColor: Colors.red.shade800,textColor: Colors.white);
//               return ForgotPassword();
//               // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ForgotPassword(),));
//             }else if(result["status"]=="exist"){
//               var otp=result["otp"];
//               var shopId=result["shop_id"];
//                 // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => EnterOtp(otp: otp,shopId: shopId,),));
//                 return EnterOtp(otp: otp, shopId: shopId);
//             }
//       //       if(result["status"]=="not exist"){
//       //   error="Enter a registered number";
//       // }else{
//       //   print(result["otp"]);
//       //   return
//       // }
//             // return SizedBox();
