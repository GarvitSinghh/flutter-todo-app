// Custom Button

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onpress;
  final bool loading;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.onpress,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    double scaleFactor = queryData.size.height / 820;

    return SizedBox(
      width: double.infinity,
      child: SizedBox(
        height: scaleFactor * 50,
        child: ElevatedButton(
          onPressed: onpress,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            backgroundColor: color,
          ),
          child: !loading ? Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 15.0),
          ) : Transform.scale(scale: 0.5, child: const AspectRatio(aspectRatio: 1, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))),
        ),
      ),
    );
  }
}
