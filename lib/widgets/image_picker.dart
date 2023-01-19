import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/permissions/camera_permission.dart';
import 'package:spencer/permissions/storage_permission.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/utilities/colors.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:spencer/utilities/url.dart';

String profileImageUrl = "assets/images/avatar.png";
// XFile image = XFile("assets/images/avatar.png");
String? base64Image;
File? imageFile;

class ProfilePicker extends StatefulWidget {
  const ProfilePicker({Key? key}) : super(key: key);

  @override
  State<ProfilePicker> createState() => _ProfilePickerState();
}

class _ProfilePickerState extends State<ProfilePicker> {
  final ImagePicker _picker = ImagePicker();
  // File image;

  Future getImage() async {}

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          height: height * 0.12,
          child: Center(
            child: images == null
                ? shopImage == "default_shop.jpg"
                    ? const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            AssetImage("assets/images/shopimage.png"),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage(shopPicDirectory + shopImage!),
                      )
                : CircleAvatar(
                    radius: 50,
                    backgroundImage: FileImage((File(images!.path))),
                  ),
          ),
        ),
        TextButton(
            onPressed: () async {
              _pickImage();
              // var result = await requestStoragePermission();
              // var result2 = await requestCameraPermission();
              // print(result2);
              // if (result == "granted" && result2=="granted") {

              //   try {
              //     images = await _picker.pickImage(source: ImageSource.gallery);
              //     if (images != null) {
              //       imageFile = File(images!.path);
              //       //  print(imageFile);
              //       // print(images);

              //       base64Image = base64Encode(imageFile!.readAsBytesSync());
              //       // print(base64Image);
              //       if (base64Image != null) {
              //         var result =
              //             await uploadShopImage(base64Image!, savedShopId);
              //         // print(result);
              //       }
              //       Future.delayed(const Duration(milliseconds: 300), () {
              //         setState(() {});
              //       });
              //     }
              //   } catch (e) {
              //     debugPrint("Image picker error " + e.toString());
              //   }
              // } else if (result == "permanently denied" || result2=="permanently denied") {
              //   // Navigator.of(context).pop();
              //   await openAppSettings();
              // } else {}
            },
            child: Center(
              child: Text(
                "Change shop image",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            )),
      ],
    );
  }

  _pickImage() async {
    var result = await requestStoragePermission();
    var result2 = await requestCameraPermission();
    if (result == "granted" && result2 == "granted") {
      try {
        images = await _picker.pickImage(source: ImageSource.gallery);
        if (images != null) {
          imageFile = File(images!.path);
          //  print(imageFile);
          // print(images);

          base64Image = base64Encode(imageFile!.readAsBytesSync());
          // print(base64Image);
          if (base64Image != null) {
            // var result = 
            await uploadShopImage(base64Image!, savedShopId);
            // print(result);
          }
          Future.delayed(const Duration(milliseconds: 300), () {
            setState(() {});
          });
        }
      } catch (e) {
        debugPrint("Image picker error " + e.toString());
      }
    } else if (result == "permanently denied" ||
        result2 == "permanently denied") {
      // Navigator.of(context).pop();
      // await openAppSettings();
      showDialog(
          context: context,
          builder: (context) {
            return _buildDialog(context);
          });
    } else {}
  }

  Widget _buildDialog(BuildContext context) => AlertDialog(
          title: Text(
            "Permission is permenently denied,go to settings and allow permission",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: mainColor),
              onPressed: () async {
                await openAppSettings();
              },
              child: Text(
                'Go to settings',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(fontWeight: FontWeight.w400, color: Colors.black),
              ),
            ),
          ]);
}
