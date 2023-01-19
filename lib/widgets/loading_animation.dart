import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingAnimation extends StatelessWidget {
  final bool transparent;
  const LoadingAnimation({Key? key, this.transparent = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      color: transparent ? Colors.transparent : Colors.white,
      child: Center(
          child: LoadingAnimationWidget.twoRotatingArc(
              color: const Color(0xff2e5266), size: 35)),
    );
  }
}

class DialogLoadingAnimation extends StatelessWidget {
  final bool pleaseWait;
  const DialogLoadingAnimation({Key? key, this.pleaseWait = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      elevation: 2,
      backgroundColor: Colors.white,
      insetPadding:
          EdgeInsets.symmetric(vertical: height * 0.1, horizontal: width * 0.2),
      child: Container(
        height: height * 0.15,
        width: width * 0.17,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.01,
            ),
            SizedBox(height: height * 0.05, child: const LoadingAnimation()),
            SizedBox(
              height: height * 0.014,
            ),
            pleaseWait
                ? Text(
                    "please wait...",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class LoadingAnimation2 extends StatelessWidget {
  const LoadingAnimation2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      width: width,
      child: Center(
          child: LoadingAnimationWidget.prograssiveDots(
              color: const Color(0xff2e5266), size: 40)),
    );
  }
}
