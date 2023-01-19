import 'package:flutter/material.dart';
import 'package:spencer/utilities/global_variables.dart';

class RangsSliders extends StatefulWidget {
  double start;
  double end;
  RangsSliders({Key? key, required this.start, required this.end})
      : super(key: key);

  @override
  State<RangsSliders> createState() => _RangsSlidersState();
}

class _RangsSlidersState extends State<RangsSliders> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.03, horizontal: width * 0.03),
        alignment: Alignment.center,
        height: height * 0.2,
        width: width,
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RangeSlider(
              values: RangeValues(widget.start, widget.end),
              onChanged: (value) {
                setState(() {
                  widget.start = value.start;
                  widget.end = value.end;
                });
                tempMin = widget.start;
                tempMax = widget.end;
              },
              inactiveColor: Colors.yellow.shade50,
              activeColor: const Color(0xff2e5266),
              min: 0,
              max: 5000,
              labels: RangeLabels(widget.start.round().toString(),
                  widget.end.round().toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: height * 0.07,
                  width: width * 0.3,
                  color: Colors.grey.shade300,
                  child: Center(
                      child: Text(
                    widget.start.round().toString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
                ),
                SizedBox(
                  width: width * 0.03,
                ),
                Container(
                  height: height * 0.07,
                  width: width * 0.3,
                  color: Colors.grey.shade300,
                  child: Center(
                      child: Text(
                    widget.end.round().toString(),
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
                ),
              ],
            )
          ],
        ));
  }
}
