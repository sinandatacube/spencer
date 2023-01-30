import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/extra/help.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/screens/login.dart';
import 'package:spencer/screens/manage_account.dart';
import 'package:spencer/screens/my_orders.dart';
import 'package:spencer/screens/support.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  DB database = DB();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: height * 0.3,
            width: width,
            child: DrawerHeader(
              decoration: BoxDecoration(color: mainColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: CircleAvatar(
                  //     radius: 35.sp,
                  //     backgroundImage: NetworkImage(
                  //         "https://www.shoppingbazar.in/uploads/images/d3871213503f27bdbd604443b8aece711540542619.jpg"),
                  //   ),
                  // ),
                  // const ProfilePicker(),
                  // Text(
                  //   "Shop Id:",
                  //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  //       fontWeight: FontWeight.w600, color: Colors.black),
                  // ),
                  // SizedBox(height: height * 0.01),
                  // Text(
                  //   savedShopId,
                  //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  //       fontWeight: FontWeight.w600, color: Colors.black),
                  // ),
                  // FutureBuilder(builder: ())

                  images == null
                      ? shopImage == null ||
                              shopImage == "default_shop.jpg" ||
                              isSkip
                          ? Container(
                              width: width * 0.3,
                              height: height * 0.14,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: AssetImage(
                                        "assets/images/shopimage.png"),
                                    fit: BoxFit.cover),
                              ),
                            )
                          //  const CircleAvatar(
                          //     radius: 50,
                          //     backgroundImage:
                          //         AssetImage("assets/images/shopimage.png"),
                          //   )
                          : SizedBox(
                              height: height * 0.15,
                              width: width * 0.25,
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  shopPicDirectory + shopImage!,

                                  //  BoxFit.cover,
                                  //   memCacheWidth: 300,
                                ),
                              ),
                            )
                      : Container(
                          width: width * 0.3,
                          height: height * 0.14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: FileImage(File(images!.path)),
                                fit: BoxFit.cover),
                          ),
                        ),
                  //  CircleAvatar(
                  //     radius: 50,
                  //     backgroundImage: FileImage((File(images!.path))),
                  //   ),
                  SizedBox(height: height * 0.01),
                  if (!isSkip)
                    Text(
                      "Shop Id: $savedShopId",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.card_giftcard,
                color: Colors.black, size: Theme.of(context).iconTheme.size),
            title: Text(
              'My Orders',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const MyOrders(),
              ));
            },
          ),
          // ListTile(
          //   leading: Icon(Icons.post_add, color: Colors.black, size: 20.sp),
          //   title: Text(
          //     'Address',
          //     style: TextStyle(
          //         fontSize: 12.sp,
          //         fontWeight: FontWeight.w500,
          //         color: Colors.black),
          //   ),
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          // ),
          ListTile(
            leading: Icon(Icons.person,
                color: Colors.black, size: Theme.of(context).iconTheme.size),
            title: Text(
              'Account details',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.of(context)
                  .push(
                MaterialPageRoute(
                  builder: (context) => const ManageAccount(),
                ),
              )
                  .then((value) {
                setState(() {});
              });
            },
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const Support())),
            leading: const Icon(
              Icons.support_agent_rounded,
              color: Colors.black,
            ),
            title: Text(
              "Support",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          if (!isSkip)
            ListTile(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Help())),
              leading: const Icon(
                Icons.help_outline,
                color: Colors.black,
              ),
              title: Text(
                "Help",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          // ListTile(
          //   leading: Icon(Icons.help_center,
          //       color: Colors.black, size: Theme.of(context).iconTheme.size),
          //   title: Text(
          //     'Need help',
          //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //           fontWeight: FontWeight.w400,
          //         ),
          //   ),
          //   onTap: () {
          //     // Update the state of the app
          //     // ...
          //     // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
          // ListTile(
          //   leading: Icon(Icons.announcement_sharp,
          //       color: Colors.black, size: Theme.of(context).iconTheme.size),
          //   title: Text(
          //     'About us',
          //     style: Theme.of(context).textTheme.titleMedium!.copyWith(
          //           fontWeight: FontWeight.w400,
          //         ),
          //   ),
          //   onTap: () {
          //     // Update the state of the app
          //     // ...
          //     // Then close the drawer
          //     Navigator.pop(context);
          //   },
          // ),
          isSkip
              ? ListTile(
                  leading: Icon(Icons.login_outlined,
                      color: Colors.black,
                      size: Theme.of(context).iconTheme.size),
                  title: Text(
                    'Login',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                )
              : ListTile(
                  leading: Icon(Icons.logout_outlined,
                      color: Colors.black,
                      size: Theme.of(context).iconTheme.size),
                  title: Text(
                    'Logout',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                  onTap: () async {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                    showDialog(context: context, builder: _buildDialog);
                  },
                ),
          const Spacer(),
          ListTile(
            title: Center(
              child: Image.asset(
                "assets/images/logoname.png",
                height: 10,
                width: 50,
              ),
            ),
            subtitle: const Center(
            child: Text(packageInfo?.version ?? "Unknown"),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDialog(BuildContext context) => AlertDialog(
        title: Text(
          'Are you sure you want to Logout?',
          style: Theme.of(context)
              .textTheme
              .titleSmall!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: mainColor),
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'No',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w600, color: Colors.black),
            ),
          ),
          TextButton(
              onPressed: () async {
                var sp = await SharedPreferences.getInstance();
                // var user =
                await sp.setString("shopId", "");
                // var token =
                await sp.setString("fcm_token", "");
                await sp.setString("pass", "");
                database.clearData();
                // var result =
                await database.getdata();
                images = null;
                savedShopId = "";
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const Login(),
                    ),
                    (route) => false);
              },
              child: Text("Yes",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w600, color: Colors.black)))
        ],
      );
}
