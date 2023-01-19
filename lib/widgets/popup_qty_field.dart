import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spencer/db_service/db_functions.dart';
import 'package:spencer/utilities/colors.dart';
import '../utilities/global_variables.dart';

class PopUpQtyField extends StatefulWidget {
  final List cartItems;
  final String productId;
  final int index;
  const PopUpQtyField(
      {Key? key,
      required this.cartItems,
      required this.index,
      required this.productId})
      : super(key: key);

  @override
  State<PopUpQtyField> createState() => _PopUpQtyFieldState();
}

class _PopUpQtyFieldState extends State<PopUpQtyField> {
  TextEditingController qtyController = TextEditingController();
  List tempProdIds = [];
  DB database = DB();
  @override
  void initState() {
    super.initState();
    tempProdIds = List.from(prodIds);
    // tempProdIds=prodIds.map((e) => e).toList();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 16,
      child: Container(
        height: height * 0.22,
        width: width * 0.6,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.05, vertical: height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "AED ",
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w400, color: Colors.red.shade700),
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Text(
                  "${widget.cartItems[widget.index]["w_rate"]}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Container(
                  height: height * 0.07,
                  width: width * 0.2,
                  padding: const EdgeInsets.only(top: 5, left: 10),
                  child: TextFormField(
                    autofocus: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(4),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: "qty",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "min ${widget.cartItems[widget.index]["min_order"]} \nmax ${widget.cartItems[widget.index]["max_order"]}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                )
              ],
            ),
            // SizedBox(
            //   height: height * 0.02,
            // ),
            Expanded(
              child: Center(
                child: SizedBox(
                  height: height * 0.06,
                  // width: width * 0.25,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                    onPressed: () async {
                      String error = "";

                      if (qtyController.text.isNotEmpty) {
                        var updatedQty = int.parse(qtyController.text);
                        int min = int.parse(
                            widget.cartItems[widget.index]["min_order"]);
                        int max = int.parse(
                            widget.cartItems[widget.index]["max_order"]);
                        if (qtyController.text.isEmpty) {
                          error = "Quantity is empty";
                        } else if (updatedQty < min) {
                          error = "Minimum quantity is $min";
                        } else if (updatedQty > max) {
                          error = "Maximum quantity is $max";
                        } else {
                          qty[widget.index] = updatedQty;

                          await database.updateQuantity(
                              updatedQty, widget.productId);
                          Navigator.of(context).pop();
                        }
                      } else {
                        error = "Quantity is empty";
                      }

                      if (error != "") {
                        Fluttertoast.cancel();
                        Fluttertoast.showToast(
                            msg: error,
                            fontSize: 15,
                            textColor: Colors.white,
                            backgroundColor: Colors.red.shade600);
                      }
                    },
                    child: Text(
                      "confirm",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
