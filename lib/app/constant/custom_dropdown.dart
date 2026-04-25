import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'dropdown_controller.dart';

class CustomDropdown<T> extends StatelessWidget {
  final DropdownController<T> controller;
  final List<T> items;
  final String hintText;
  final String Function(T) displayText;
  final IconData? icon;

  const CustomDropdown({
    super.key,
    required this.controller,
    required this.items,
    required this.displayText,
    this.hintText = 'Select',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown Header
        Obx(
          () => GestureDetector(
            onTap: controller.toggle,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: AppColors.appColor),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      controller.selectedItem.value == null
                          ? hintText
                          : displayText(controller.selectedItem.value as T),
                      style: TextStyle(
                        color: controller.selectedItem.value == null
                            ? Colors.grey
                            : Colors.black,
                      ),
                    ),
                  ),
                  Icon(
                    controller.isOpen.value
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
        ), // Dropdown Items
        Obx(
          () => controller.isOpen.value
              ? Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (_, index) {
                      final item = items[index];
                      return InkWell(
                        onTap: () => controller.selectItem(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Text(displayText(item)),
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
