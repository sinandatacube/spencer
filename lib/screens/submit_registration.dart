import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spencer/api/api_with_model.dart';
import 'package:spencer/modal/details_model.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/order_failed.dart';
import 'package:spencer/screens/registration.dart';
import 'package:spencer/screens/registration_success.dart';
import 'package:spencer/widgets/loading_animation.dart';

class SubmitRegistration extends StatelessWidget {
  final Details details;
  SubmitRegistration({Key? key, required this.details});
  late Details data;

  @override
  Widget build(BuildContext context) {
    data = details;
    return Scaffold(
      body: FutureBuilder(
        future: submitRegistration(data),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var result = snapshot.data;
            if (result == 'success') {
              return RegistrationSuccess(
                  mobileNumber: data.mobileNumber, password: data.password);
            } else if (result == 'failed') {
              return const OrderFailed();
            } else {
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text(
              //     result,
              //     style: snackbarTextStyle,
              //   ),
              //   backgroundColor: Colors.red,
              // ));
              Fluttertoast.showToast(
                  msg: result,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  toastLength: Toast.LENGTH_LONG);
              return Registration(
                details: data,
              );
            }
          } else if (snapshot.hasError) {
            var error = snapshot.error;
            if (error == "Socket error") {
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
//             var result = snapshot.data;
//             if (result == 'success') {
//               return RegistrationSuccess(
//                   mobileNumber: data.mobileNumber, password: data.password);
//             } else if (result == 'failed') {
//               //TODO failed page
//               return RegistrationSuccess(mobileNumber: "no data", password: "no data");
//             }
//           } else if(snapshot.hasError){
//             var error=snapshot.error;
//             if(error=="Socket error"){

//             return NoNetwork();

//             }else{
//               return const  ErrorPage();
//             }
//           }else {
//             return LoadingAnimation();
//           }
