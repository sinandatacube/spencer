import 'package:flutter/material.dart';

class AccountDetailsWidget extends StatelessWidget {
  final String title;
  final String content;
  const AccountDetailsWidget(
      {Key? key, required this.content, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(
          horizontal: width * 0.04, vertical: height * 0.005),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
          // alignment: Alignment.center,
          height: height * 0.15,
          width: width,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: width * 0.03, top: height * 0.01),
                child: Text(
                  title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Expanded(
                  child: Center(
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Colors.black),
                ),
              ))
            ],
          )),
    );
  }
}
