import 'dart:async';

import 'package:flutter/material.dart';
import '../Helper/Color.dart';

setSnackbar(String msg, context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: black,
        ),
      ),
      duration: const Duration(
        seconds: 2,
      ),
      backgroundColor: white,
      elevation: 1.0,
    ),
  );
}
// Option 1: Custom Overlay Method (Recommended)
void showCenterMessage(String message, BuildContext context) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.5 - 40,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );

  Overlay.of(context)?.insert(overlayEntry);

  // Auto remove after 3 seconds
  Timer(Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}

// Usage:
// showCenterMessage(getTranslated(context, "Please Add Questions Value")!, context);

// Option 2: Custom Dialog Method
void showCenterDialog(String message, BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    },
  );

  // Auto close after 2 seconds
  Timer(Duration(seconds: 2), () {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  });
}

// Usage:
// showCenterDialog(getTranslated(context, "Please Add Questions Value")!, context);

// Option 3: Positioned Snackbar (if you want to modify your existing setSnackbar method)
void setSnackbarCenter(String message, BuildContext context) {
  final snackBar = SnackBar(
    content: Text(
      message,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.only(
      bottom: MediaQuery.of(context).size.height * 0.5 - 40,
      left: 20,
      right: 20,
    ),
    backgroundColor: Colors.black87,
    duration: Duration(seconds: 3),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

// Usage:
// setSnackbarCenter(getTranslated(context, "Please Add Questions Value")!, context);

// Option 4: Toast-like Center Message (Requires fluttertoast package)
/*
void showCenterToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
*/