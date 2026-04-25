import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samadhantra/app/constant/app_color.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final bool readOnly;
  final int maxLines;
  final FocusNode? focusNode;
  final bool enabled;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;
  final EdgeInsetsGeometry contentPadding;
  final Color? fillColor;

  // 🔹 Password & input control
  final bool isPassword;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCounter;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.labelText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.focusNode,
    this.enabled = true,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
    this.contentPadding =
    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.fillColor,
    this.isPassword = false,
    this.maxLength,
    this.inputFormatters,
    this.showCounter = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword || widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelText != '' && widget.labelText != null? Text('${widget.labelText}',style: TextStyle(color: AppColors.black),): SizedBox.shrink(),
        const SizedBox(height: 4),
        TextFormField(

          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          maxLines: widget.maxLines,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
            labelStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
            alignLabelWithHint: widget.maxLines > 1,
            filled: true,
            fillColor: widget.fillColor ?? Colors.grey.shade50,
            counterText: widget.showCounter ? null : '',
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: theme.primaryColor,size: 16.h,)
                : null,

            // 👁 Password visibility toggle
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.appColor,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : widget.suffixIcon != null
                ? Icon(widget.suffixIcon, color: theme.primaryColor)
                : null,

            contentPadding: widget.contentPadding,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

