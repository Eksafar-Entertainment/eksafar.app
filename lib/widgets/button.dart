import 'package:flutter/material.dart';

class ThemeButton extends MaterialButton{
  String label;
  Color? color;
  Color? labelColor;
  double? height = 30;
  double? minWidth = 10;
  double? borderRadius = 10;
  bool? selected = false;
  bool? isLoading = false;


  ThemeButton({
    super.key,
    required super.onPressed,
    required this.label,
    this.color,
    this.labelColor,
    this.selected,
    this.height,
    this.minWidth,
    this.borderRadius,
    this.isLoading
  });

  @override
  Widget build(BuildContext context) {
    color = color?? Theme.of(context).buttonColor;
    labelColor = labelColor ?? Colors.white;

    Color? _color = color;
    Color? _labelColor = labelColor;
    if(selected ?? false){
      _color = labelColor;
      _labelColor = color;
    }

    return ButtonTheme(
      height: height ?? 30,
      minWidth: minWidth??10,
      child: MaterialButton(
        color: _color,
        elevation: 0,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? (height??30)/4),
          borderSide: BorderSide(width: 0, color: Colors.transparent),
        ),
        onPressed: onPressed,
        child: (isLoading ?? false)? SizedBox(
          height: ((height??30)/3),
          width: ((height??30)/3),
          child: CircularProgressIndicator(color: _labelColor,),
        ): Text(
          label.toUpperCase(),
          style: TextStyle(
              fontSize: ((height??30)/3.5),
              color: _labelColor,
              letterSpacing: 1.8,
              fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }

}