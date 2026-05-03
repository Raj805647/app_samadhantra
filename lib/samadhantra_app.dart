import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/constant/app_color.dart';
import 'app/global_routes/app_pages.dart';
import 'app/global_routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, __) {
          return GetMaterialApp(
            title: 'Samadhantra',
            debugShowCheckedModeBanner: false,
      
            // ✅ Decide route ONCE at startup
            /* initialRoute:PrefService.isFirstTime
                ? AppRoutes.onboardingScreen
                : ppPages.routes,*/
            initialRoute: AppRoutes.splash,
      
            getPages: AppPages.routes,
      
            theme: ThemeData(useMaterial3: false,
              primaryColor: AppColors.appColor,
              scaffoldBackgroundColor: AppColors.background,
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
          );
        },
      ),
    );
  }
}
