import 'package:flutter/material.dart';
import '../utilities/global_variables.dart';

enum Sortby { lowToHigh, highToLow, aToZ, zToA }

Sortby? _character = Sortby.lowToHigh;

class Sort extends StatefulWidget {
  const Sort({Key? key}) : super(key: key);

  @override
  State<Sort> createState() => _SortState();
}

class _SortState extends State<Sort> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.38,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: height * 0.01),
                alignment: Alignment.centerLeft,
                height: height * 0.05,
                width: width,
                child: Text(
                  "Sort by",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.grey.shade600, fontWeight: FontWeight.w600),
                )),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Price: Low - high",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Radio(
                    value: Sortby.lowToHigh,
                    groupValue: _character,
                    onChanged: (Sortby? value) {
                      setState(() {
                        _character = value;
                      });
                      sortType = "lowToHigh";
                      Navigator.of(context).pop();
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Price: High - Low",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Radio(
                    value: Sortby.highToLow,
                    groupValue: _character,
                    onChanged: (Sortby? value) {
                      setState(() {
                        _character = value;
                      });
                      sortType = "highToLow";

                      Navigator.of(context).pop();
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "A\u{2192}Z",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Radio(
                    value: Sortby.aToZ,
                    groupValue: _character,
                    onChanged: (Sortby? value) {
                      setState(() {
                        _character = value;
                      });
                      sortType = "aToz";
                      Navigator.of(context).pop();
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Z\u{2192}A",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Radio(
                    value: Sortby.zToA,
                    groupValue: _character,
                    onChanged: (Sortby? value) {
                      setState(() {
                        _character = value;
                      });
                      sortType = "ztoa";
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
