import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final String? iconString;
  final VoidCallback? onButtonPress;
  final double? width;
  final bool disabled;
  final bool isLoading;
  const CustomButton(
      {Key? key,
      required this.buttonText,
      required this.onButtonPress,
      this.iconString,
      this.width,
      this.disabled = false,
      this.isLoading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: disabled || isLoading ? () {} : onButtonPress, child: Padding(
      padding: const EdgeInsets.all(8),
      child: isLoading ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
          )) : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconString != null)
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: SvgPicture.asset(iconString!)),
          Text(
            buttonText,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
      style: ElevatedButton.styleFrom(
          primary: Color(0xff462f92).withOpacity(disabled ? 0.5 : 1),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
              side: const BorderSide(color: Colors.transparent,)
          ),
          splashFactory:
          disabled ? NoSplash.splashFactory : InkSplash.splashFactory,
          minimumSize: Size(width != null ? width! : 0, 50)),
    );
  }
}
