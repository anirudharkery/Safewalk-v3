import 'package:flutter/material.dart';
// import 'package:taxi_driver/common/color_extension.dart';

class LocationSelectButton extends StatelessWidget {
  final String title;
  final String placeholder;
  final Color color;
  final String value;
  final bool isSelect;
  final VoidCallback onPressed;

  const LocationSelectButton(
      {super.key,
      required this.title,
      required this.placeholder,
      required this.color,
      required this.value,
      this.isSelect = false,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onPressed,
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                border: isSelect ? Border.all(color: color, width: 2) : null,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: isSelect ? color.withOpacity(0.2) : Colors.black12,
                      blurRadius: 2,
                      spreadRadius: 2)
                ]),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(10)),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Text(
                    value == "" ? placeholder : value,
                    textAlign: TextAlign.left,
                    maxLines: 1,
                    style: TextStyle(
                      color: value == "" ? Colors.purple : Colors.red,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  color: Colors.red,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}

enum RoundButtonType { primary, secondary, red, boarded }

class RoundButton extends StatelessWidget {
  final String title;
  final RoundButtonType type;
  final VoidCallback onPressed;

  const RoundButton(
      {super.key,
      required this.title,
      this.type = RoundButtonType.primary,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      minWidth: double.maxFinite,
      elevation: 0,
      color: type == RoundButtonType.primary
          ? Colors.red
          : type == RoundButtonType.secondary
              ? Colors.red
              : type == RoundButtonType.red
                  ? Colors.red
                  : Colors.transparent,
      height: 45,
      shape: RoundedRectangleBorder(
          side: type == RoundButtonType.boarded
              ? BorderSide(color: Colors.red)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(25)),
      child: Text(
        title,
        style: TextStyle(
          color: type == RoundButtonType.boarded ? Colors.red : Colors.red,
          fontSize: 16,
        ),
      ),
    );
  }
}

extension AppContext on BuildContext {
  Size get size => MediaQuery.sizeOf(this);
  double get width => size.width;
  double get height => size.height;

  Future push(Widget widget) async {
    return Navigator.push(
      this,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  void pop() async {
    return Navigator.pop(this);
  }
}
