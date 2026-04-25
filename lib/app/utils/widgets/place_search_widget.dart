import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_style.dart';

import 'map_controller.dart';

class PlaceSearchWidget extends StatelessWidget {
  final bool isEdit;

  final controller;
  final MapController mapController = Get.put(MapController());
  final String? Function(String?)? validator;

  PlaceSearchWidget({super.key,required this.controller,this.validator,this.isEdit =false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search TextField
        SizedBox(
          width: AppStyle.widthPercent(context, 90),
          child: TextFormField(
            style: TextStyle(fontSize: !isEdit! ? 14.sp : 12.sp),
            controller: controller.addressController,
            validator: (value) {
              if (validator != null) return validator!(value);
              return null;
            },

            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: 'Address',
              hintStyle: TextStyle(color: Colors.grey,),
              label: !isEdit! ? null : const Text("Address"),
              labelStyle: TextStyle(fontSize: 12.sp),
              // prefixIcon: const Icon(Icons.location_on, size: 18, color: AppColors.appColor),
              disabledBorder: InputBorder.none, // Add this

              // ✅ NORMAL BORDER
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.appColor, width: 2),
              ),

              // ✅ ERROR BORDER
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),

              // ✅ ✅ CONTROL ERROR TEXT HEIGHT
              errorStyle: const TextStyle(
                fontSize: 11,
                height: 1.1,
              ),

              suffixIcon: Obx(() {
                if (mapController.searchQuery.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      // Get.find<SignUpScreenController>().addressController.clear();
                      mapController.clearSearch();
                      controller.addressController.clear();
                    },
                  );
                }
                return const SizedBox();
              }),
              // filled: true,
              // fillColor: Colors.white, // Change this to transparent
            ),
            onChanged: (value) {
              mapController.searchQuery.value = value;
              if (value.length > 2) {
                mapController.searchPlaces(value);
              } else {
                mapController.predictions.clear();
              }
            },
          ),
        ),
        // Loading indicator
        Obx(() => mapController.isLoading.value
            ? const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        )
            : const SizedBox.shrink()),

        // Predictions list
        Obx(() => mapController.predictions.isNotEmpty
            ? Container(
          height: AppStyle.heightPercent(context, 22),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 4.0,
                color: Colors.grey.withOpacity(0.3),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: mapController.predictions.length,
            itemBuilder: (context, index) {
              final prediction = mapController.predictions[index];
              return ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                leading: const Icon(Icons.location_on, color: Colors.blue, size: 18),
                title: Text(
                  prediction.mainText,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                subtitle: Text(prediction.secondaryText),
                onTap: () {
                  // Call getPlaceDetails first, then handle the result
                  mapController.getPlaceDetails(prediction.placeId).then((_) {
                    // This code runs after getPlaceDetails completes
                    if (mapController.selectedPlace.value != null) {
                      controller.addressController.text = mapController.selectedPlace.value!.address;
                    }
                  });
                  // Hide keyboard immediately
                  FocusScope.of(context).unfocus();
                },
              );
            },
          ),
        )
            : const SizedBox.shrink()),
      ],
    );
  }
}