// import 'package:flutter/material.dart';

// class Sample extends StatefulWidget {
//   const Sample({Key? key}) : super(key: key);

//   @override
//   State<Sample> createState() => _SampleState();
// }

// class _SampleState extends State<Sample> {
//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     double width = MediaQuery.of(context).size.width;
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(30),
//           color: Colors.white,
//           border: Border.all(
//             color: Colors.white,
//           )),
//       child: GridView.builder(
//           itemCount: 50,
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               childAspectRatio: 0.9,
//               crossAxisCount: 3,
//               crossAxisSpacing: width * 0.015,
//               mainAxisSpacing: height * 0.015),
//           itemBuilder: (context, index) {
//             Color color;
//             print(index);
//             print(index % 2);
//             if (index % 2 == 0) {
//               color = Colors.red.shade900;
//             } else {
//               color = Colors.yellow.shade900;
//             }
//             return Container(
//                 decoration: BoxDecoration(
//                     color: color, border: Border.all(color: Colors.black)));
//           }),
//     );
//   }
// }
