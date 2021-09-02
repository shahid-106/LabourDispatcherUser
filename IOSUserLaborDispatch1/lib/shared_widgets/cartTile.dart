// import '../configs/app_colors.dart';
// import '../models/cart.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class CartTile extends StatelessWidget {
//   final Cart cart;
//   final Function addToCartFn;
//   final Function markFavouriteFn;
//
//   CartTile({this.cart, this.addToCartFn, this.markFavouriteFn});
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {},
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(left: 5),
//             child: Row(
//               //crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Container(
//                   width: 90.0,
//                   height: 90.0,
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(5.0),
//                       image: DecorationImage(
//                           image: NetworkImage(cart.product.images[0]),
//                           fit: BoxFit.cover)),
//                 ),
//                 Expanded(
//                   child: Container(
//                     padding: EdgeInsets.only(left: 10),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisSize: MainAxisSize.max,
//                               mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Expanded(
//                                   flex: 5,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         cart.product.name,
//                                         style: TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.w600),
//                                       ),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.shopping_cart,
//                                             color: Colors.grey,
//                                             size: 16,
//                                           ),
//                                           Text(
//                                             ' ' + cart.product.price.toString() + '  |  ',
//                                             style: TextStyle(
//                                                 fontSize: 16,
//                                                 color: Colors.grey,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                           Icon(
//                                             Icons.thumb_up,
//                                             color: Colors.black,
//                                             size: 16,
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 Expanded(
//                                     flex: 1,
//                                     child: IconButton(
//                                       icon: Icon(Icons.bookmark_border,
//                                           color: Colors.grey),
//                                       iconSize: 24,
//                                     )),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   'Rs ' + cart.product.price.toString(),
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color: AppColors.APP_PRIMARY_COLOR,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 Text(
//                                   '  |  ',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.grey,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//
//                               ],
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.add_circle,
//                                   color: AppColors.APP_PRIMARY_COLOR),
//                               iconSize: 24,
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10.0),
//         ],
//       ),
//     );
//   }
// }
