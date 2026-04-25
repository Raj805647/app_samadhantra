import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_textstyle.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isBackButton;
  final List<Widget>? actions;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.isBackButton = true,
    this.actions,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 2);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: isBackButton,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.appColor,
      elevation: 0,
      centerTitle: true,
      flexibleSpace: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.appColor, AppColors.appColor2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.appColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
      leading: isBackButton
          ? Container(
        width: 42,
        height: 42,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 15,
            color: AppColors.white,
          ),
          splashRadius: 24,
          padding: EdgeInsets.zero, // IMPORTANT
          constraints: const BoxConstraints(), // IMPORTANT
        ),
      ): null,
      title: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          title,
          style: AppTextStyles.title.copyWith(color: AppColors.white,fontSize: 15.sp)
        ),
      ),
      actions: actions ?? [],
    );
  }
}
