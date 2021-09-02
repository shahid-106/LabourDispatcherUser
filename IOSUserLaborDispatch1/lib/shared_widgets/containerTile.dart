import '../configs/app_colors.dart';
import 'package:flutter/material.dart';

class ContainerTile extends StatelessWidget {
  final String name;
  Function onPressed;

  ContainerTile({this.name, this.onPressed});

  @override
  Widget build(BuildContext context) {

    // Padding(
    //   padding: EdgeInsets.only(top: 5, left: 10),
    //   child: Row(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: <Widget>[
    //       Container(
    //         width: 60.0,
    //         height: 60.0,
    //         margin: EdgeInsets.only(top: 10.0),
    //         padding: EdgeInsets.all(0),
    //         decoration: BoxDecoration(
    //             border: Border.all(
    //                 color: Colors.white,
    //                 style: BorderStyle.solid,
    //                 width: 1.5),
    //             borderRadius: BorderRadius.circular(5.0),
    //             image: DecorationImage(
    //                 image: NetworkImage('https://raw.githubusercontent.com/hacktons/convex_bottom_bar/master/doc/preview.png'),
    //                 fit: BoxFit.cover)),
    //       ),
    //       Container(
    //         width: MediaQuery.of(context).size.width * 0.5,
    //         padding: EdgeInsets.only(top: 5, left: 10),
    //         child: Text(
    //           'Next',
    //           overflow: TextOverflow.ellipsis,
    //           style: TextStyle(
    //               fontSize: 20,
    //               letterSpacing: 0.5,
    //               fontFamily: 'Montserrat-M'),
    //         ),
    //       ),
    //       Spacer(),
    //       Padding(
    //         padding:
    //         EdgeInsets.only(right: 10, left: 5),
    //         child: Card(
    //           elevation: 5.0,
    //           shape: RoundedRectangleBorder(
    //               borderRadius:
    //               BorderRadius.circular(3.0)),
    //           child: Padding(
    //             padding: EdgeInsets.all(5.0),
    //             child: Text(
    //               'NEW',
    //               textAlign: TextAlign.center,
    //               style: TextStyle(
    //                   fontSize: 12,
    //                   letterSpacing: 0.5,
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.bold,
    //                   fontFamily: 'Montserrat-M'),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // ),

    return GestureDetector(
      onTap: onPressed,
      // child: Container(
      //     width: MediaQuery.of(context).size.width * 0.7,
      //     decoration: DecorationBoxes.decorationWhiteAllBorder(),
      // ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        // margin: EdgeInsets.only(
        //   top: 5,
        //   bottom: 5,
        // ),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0)),
          elevation: 3.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 100,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Stack(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset('assets/demo.jpg', fit: BoxFit.fill,)
                        ),
                        // child: Image.network('https://raw.githubusercontent.com/hacktons/convex_bottom_bar/master/doc/preview.png', fit: BoxFit.cover,)
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: AppColors.APP_WHITE_COLOR,
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Text(
                                '1 hours',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat-M'),
                              ),
                          ),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                                color: AppColors.APP_WHITE_COLOR,
                                borderRadius: BorderRadius.circular(10.0)),
                            child: Text(
                              'Earring',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  letterSpacing: 0.5,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat-M'),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shoulder Routine',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),

                  ],
                ),
              ),
              SizedBox(height: 5.0),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text('Shoulder & Back weight Routine',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
                ),
              ),
            ],
          ),
        ),
    ));
  }


}
