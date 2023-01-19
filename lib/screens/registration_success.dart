// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// class RegisterStatus extends StatelessWidget {
//   const RegisterStatus({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return Scaffold(
//           // backgroundColor: Color(0xff107cb5),

//           body: SafeArea(
//               child: Column(
//             children: [
//               Container(
//                 height: 60.h,
//                 decoration: BoxDecoration(color: Colors.green.shade700),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 27.h,
//                       width: 100.w,
//                       margin: EdgeInsets.symmetric(horizontal: 30.w),
//                       decoration: BoxDecoration(
//                         color: Colors.green.shade700,
//                         shape: BoxShape.circle,
//                         border: Border.all(color: Colors.white, width: 2),
//                       ),
//                       child: Icon(
//                         Icons.check,
//                         size: 70.sp,
//                         color: Colors.white,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 2.h,
//                     ),
//                     Text(
//                       "Registration successfully submited",
//                       style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16.sp,
//                           fontWeight: FontWeight.w400),
//                     )

//                     // SizedBox(height: 2.h,),
//                     // Center(child: Text("Your Registration submited\nsuccessfully",textAlign: TextAlign.center,style:TextStyle(fontWeight:FontWeight.w700,fontSize: 17.sp,color: Colors.white)))
//                   ],
//                 ),
//               ),
//               SizedBox(height: 3.h,),
//                 Padding(
//                   padding:  EdgeInsets.symmetric(horizontal: 10.w),
//                   child: Text("Your Registration will approved within 2-3 buisness days",style: TextStyle(color:Colors.grey.shade500,fontSize: 13.sp,fontWeight: FontWeight.w500)
//                   ),
//                 ),
//             ],
//           )),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:spencer/screens/login.dart';
import 'package:spencer/utilities/colors.dart';

class RegistrationSuccess extends StatelessWidget {
  final String mobileNumber;
  final String password;
  const RegistrationSuccess(
      {Key? key, required this.mobileNumber, required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor: Colors.green.shade500,
      backgroundColor: darkerMainColor,
      // backgroundColor: Color(0xff107cb5),
      // backgroundColor: Color(0xff0c87b0),
      body: SafeArea(
        child: Center(
          child: Card(
            color: Colors.white,
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: height * 0.65,
              width: width * 0.7,
              decoration: BoxDecoration(
                  //  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.19,
                    width: width * 0.19,
                    // width: 100.w,
                    margin: EdgeInsets.symmetric(
                        horizontal: width * 0.05, vertical: height * 0.02),
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      Icons.check,
                      size: Theme.of(context).iconTheme.size,
                      color: Colors.white,
                    ),
                  ),
                  Text("Successfully submitted",
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: height * 0.03),
                  Text("Hold on!",
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500)),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    child: Text(
                        "Your account will activated in 2-3 business days",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500)),
                  ),
                  SizedBox(height: height * 0.02),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Text("Mobile number : $mobileNumber",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.black87)),
                  ),
                  // SizedBox(height: height * 0.005),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                    child: Text("Password : $password",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                fontWeight: FontWeight.w400,
                                color: Colors.black87)),
                  ),
                  // SizedBox(height: height * 0.02),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        height: height * 0.06,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainColor),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => const Login(),
                              ));
                            },
                            child: Text(
                              "Back to login",
                              style: Theme.of(context)
                                  .textTheme
                                  .button!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
