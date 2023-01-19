import 'package:flutter/material.dart';

// class CartCounter extends StateNotifier<int> {
//   CartCounter() : super(0);
//   void cartItemCount(int count) => state=count;

// }
// final counterProvider = StateNotifierProvider<CartCounter, int>((ref) {
//   return CartCounter();
// });
// class CartCount extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final count = ref.watch(counterProvider);
//     return Text('$count');
//   }
// }

// class Cartcalculations extends StateNotifier<double>{
//   Cartcalculations():super(0);
//   void cartCalc(double totalAmount)=> state=totalAmount;
// }
// final cartProvider = StateNotifierProvider<Cartcalculations,double>((ref) {

//   return Cartcalculations();
// });

class CartCounter extends ChangeNotifier {
  int count = 0;

  updateCount(int cartCount) {
    count = cartCount;
    notifyListeners();
  }
}
