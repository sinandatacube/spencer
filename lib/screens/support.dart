import 'package:flutter/material.dart';
import 'package:spencer/api/api.dart';
import 'package:spencer/screens/chat.dart';
import 'package:spencer/screens/fetch_customer_details.dart';
import 'package:spencer/screens/home_page.dart';
import 'package:spencer/utilities/global_variables.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  const Support({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text("Support")),
      body: FutureBuilder(
        future: fetchUserDetails(savedShopId),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return withData(context, data);
          } else {
            return withoutData(context);
          }
        },
      ),
    );
  }

  Widget withData(BuildContext context, var data) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/customersupport.png",
            height: height * 0.35,
            width: width,
          ),
          Text(
            "How can we help you",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatWidget(
                    email: data["email"], shopName: data["shop_name"]))),
            child: Container(
              height: height * 0.08,
              width: width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Image.asset("assets/images/chatsupport.png"),
                  Text(
                    "Chat Support",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          GestureDetector(
            onTap: _launchUrl,
            child: Container(
              height: height * 0.08,
              width: width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Image.asset("assets/images/callsupport.png"),
                  Text(
                    "Call Support",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget withoutData(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/customersupport.png",
            height: height * 0.35,
            width: width,
          ),
          Text(
            "How can we help you",
            style: Theme.of(context)
                .textTheme
                .headline5!
                .copyWith(fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FetchCustomerDetails())),
            child: Container(
              height: height * 0.08,
              width: width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Image.asset("assets/images/chatsupport.png"),
                  Text(
                    "Chat Support",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: height * 0.02,
          ),
          GestureDetector(
            onTap: _launchUrl,
            child: Container(
              height: height * 0.08,
              width: width * 0.8,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black54),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  Image.asset("assets/images/callsupport.png"),
                  Text(
                    "Call Support",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    final url = Uri.parse("tel:+971507182336");
    if (!await launchUrl(url)) {
      throw 'Could not launch $url';
    }
  }
}
