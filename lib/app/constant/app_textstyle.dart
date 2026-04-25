import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samadhantra/app/constant/app_color.dart';

class AppTextStyles {
  // HEADINGS
  static  TextStyle heading1 = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
  );

  static  TextStyle heading2 = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
  );

  // TITLES
  static TextStyle title = TextStyle(
    fontSize: 18.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w600,
  );

  // BODY TEXT
  static  TextStyle body = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
  );

  static  TextStyle bodyMedium = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
  );

  // SMALL / CAPTION
  static  TextStyle caption = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  // BUTTON
  static  TextStyle button = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
  );
}
