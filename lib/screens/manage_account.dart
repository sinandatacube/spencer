import 'package:flutter/material.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/error_page.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/no_network.dart';
import 'package:spencer/screens/skipped_login_alert.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/widgets/loading_animation.dart';
import '../widgets/account_details_widget.dart';
import '../widgets/image_picker.dart';

class ManageAccount extends StatelessWidget {
  const ManageAccount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    if (isSkip) {
      return const SkippedLoginAlert();
    } else {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: _buildAppBar(),
        body: _buildBody(height, width),
      );
    }
  }

/////////////////////////////////////////////////////// AppBar /////////////////////////////////////////////////////////////
  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: const Text("Account details"),
      elevation: 0,
    );
  }

  ////////////////////////////////////////////////////// body ////////////////////////////////////////////////////
  Widget _buildBody(double height, double width) {
    return FutureBuilder(
      future: fetchUserDetails(savedShopId),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data;
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Stack(
              children: [
                SizedBox(
                  width: width,
                  height: height * 1.15,
                ),
                Container(
                  height: height * 0.3,
                  width: width,
                  decoration: BoxDecoration(
                    color: mainColor,
                  ),
                ),
                const ProfilePicker(),
                Positioned(
                    top: height * 0.17,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      height: height,
                      width: width,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.01,
                            ),
                            SizedBox(
                                height: height * 0.11,
                                child: AccountDetailsWidget(
                                  content: data["trn_number"],
                                  title: "Trn number ",
                                )),
                            SizedBox(
                                height: height * 0.11,
                                child: AccountDetailsWidget(
                                  content: data["shop_name"],
                                  title: "Shop name",
                                )),
                            SizedBox(
                                height: height * 0.11,
                                child: AccountDetailsWidget(
                                  content: data["owner_name"],
                                  title: "Owner name",
                                )),
                            SizedBox(
                                height: height * 0.11,
                                child: AccountDetailsWidget(
                                  content: data["mobile"],
                                  title: "Mobile Number",
                                )),
                            SizedBox(
                                height: height * 0.11,
                                child: AccountDetailsWidget(
                                  content: data["place"],
                                  title: "Place",
                                )),
                            SizedBox(
                                height: height * 0.11,
                                child: AccountDetailsWidget(
                                  content: data["address"],
                                  title: "Address",
                                )),
                            SizedBox(
                                height: height * 0.11,
                                child: AccountDetailsWidget(
                                  content: data["pincode"],
                                  title: "Pincode",
                                )),
                            SizedBox(
                              height: height * 0.11,
                              child: AccountDetailsWidget(
                                content: data["email"],
                                title: "Email",
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          );
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
    );
  }
}
