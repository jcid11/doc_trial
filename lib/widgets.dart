import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget generalButton(BuildContext context,String title,VoidCallback onPressed) {
  return RawMaterialButton(
    onPressed: onPressed,
    child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.blue),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1,
          ),
        )),
  );
}

showSnackBar(BuildContext context, String message,
    {Color color = Colors.black, int duration = 4000}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    duration: Duration(milliseconds: duration),
    behavior: SnackBarBehavior.floating,
    content: BuildText(
      text: message,
      color: Colors.white,
    ),
  ));
}

class BuildText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? color;
  final TextDecoration? decoration;
  final int? maxLines;
  final TextOverflow? textOverflow;

  const BuildText(
      {Key? key,
        required this.text,
        this.fontSize,
        this.fontWeight,
        this.textAlign,
        this.color,
        this.maxLines,
        this.textOverflow,
        this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: textOverflow,
      style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration),
      textAlign: textAlign,
    );
  }
}

showLoading(BuildContext context,
    {required String title, bool barrierDismissible = false}) {
  return showDialog(
    context: context,
    useSafeArea: false,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 110.0,
              width: 110.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: showCircularProgress()),
                    const SizedBox(height: 8.0),
                    BuildText(text: ('$title...'))
                  ],
                ),
              )),
        ],
      );
    },
  );
}
Widget showCircularProgress(
    {double width = 30.0, double height = 30.0, double strokeWidth = 2}) {
  if (Platform.isIOS) {
    return const CupertinoActivityIndicator();
  }
  return SizedBox(
      width: width,
      height: height,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
      ));
}