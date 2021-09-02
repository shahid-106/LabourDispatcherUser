import 'package:flutter/material.dart';

class NoInternetAvailable extends StatefulWidget {

  final VoidCallback onPressed;

  NoInternetAvailable({this.onPressed});

  @override
  _NoInternetAvailableState createState() => _NoInternetAvailableState();
}

class _NoInternetAvailableState extends State<NoInternetAvailable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(
              "No Internet Available.\nPlease check your internet connection & Try Again!",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          FlatButton(
            onPressed: widget.onPressed,
            child: Text(
              "Try Again",
              style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  color: Colors.blue
              ),
            ),
          ),
        ],
      ),
    );
  }
}
