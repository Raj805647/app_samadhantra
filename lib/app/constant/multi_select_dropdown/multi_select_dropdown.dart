import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'multi_custom_dropdown.dart';

class MultiSelectCustomDropdown<T> extends StatelessWidget {
  final MultiSelectDropdownController<T> controller;
  final List<T> items;
  final String hintText;
  final String Function(T) displayText;
  final IconData? icon;
  final int? maxItemsToShow; // Max items to show before truncating
  final Widget Function(T)? customItemBuilder;
  final bool showChipView; // Whether to show chips inside dropdown
  final Function(List<T>)? onSelectionChanged;
  final bool showOtherOption; // Add this
  final String otherOptionText; // Add this
  final Function(String)? onOtherSelected; // Add this callback

  const MultiSelectCustomDropdown({
    super.key,
    required this.controller,
    required this.items,
    required this.displayText,
    this.hintText = 'Select',
    this.icon,
    this.maxItemsToShow = 2,
    this.customItemBuilder,
    this.showChipView = true,
    this.onSelectionChanged,
    this.showOtherOption = false,
    this.otherOptionText = 'Other',
    this.onOtherSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dropdown Header with Chips
        Obx(() => GestureDetector(
          onTap: controller.toggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 20, color: AppColors.appColor),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: _buildSelectedItemsDisplay(),
                    ),
                    Icon(
                      controller.isOpen
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
                // Show chips inside dropdown header
                if (showChipView && controller.selectedItems.isNotEmpty)
                  _buildChipsRow(),
              ],
            ),
          ),
        )),

        // Dropdown Items
        Obx(() => controller.isOpen
            ? Container(
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              )
            ],
          ),
          child: Column(
            children: [
              // Select All / Clear All buttons
              if (items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          if (controller.selectedItems.length ==
                              items.length) {
                            controller.clearSelection();
                          } else {
                            controller.setSelectedItems([...items]);
                          }
                          onSelectionChanged?.call(controller.selectedItems);
                        },
                        child: Text(
                          controller.selectedItems.length == items.length
                              ? 'Clear All'
                              : 'Select All',
                          style: TextStyle(
                            color: AppColors.appColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (controller.selectedItems.isNotEmpty)
                        Text(
                          '${controller.selectedItems.length} selected',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              Divider(height: 1, color: Colors.grey.shade200),
              // Items List
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.3,
                ),
                child: Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final item = items[index];
                      final isSelected = controller.isSelected(item);
                      return InkWell(
                        onTap: () {
                          controller.selectItem(item);
                          onSelectionChanged?.call(controller.selectedItems);
                        },
                        child: Container(
                          color: isSelected
                              ? AppColors.appColor.withOpacity(0.1)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              // Checkbox
                              Container(
                                width: 20,
                                height: 20,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.appColor
                                        : Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                  color: isSelected
                                      ? AppColors.appColor
                                      : Colors.transparent,
                                ),
                                child: isSelected
                                    ? Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                                    : null,
                              ),
                              // Item content
                              Expanded(
                                child: customItemBuilder != null
                                    ? customItemBuilder!(item)
                                    : Text(
                                  displayText(item),
                                  style: TextStyle(
                                    color: Colors.grey.shade800,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        )
            : const SizedBox()),
      ],
    );
  }

  // Build selected items display in header
  Widget _buildSelectedItemsDisplay() {
    if (controller.selectedItems.isEmpty) {
      return Text(
        hintText,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      );
    }

    final displayItems = controller.selectedItems.map(displayText).toList();

    if (maxItemsToShow != null &&
        displayItems.length > maxItemsToShow! &&
        !controller.isOpen) {
      final shownItems = displayItems.take(maxItemsToShow!).join(', ');
      final remainingCount = displayItems.length - maxItemsToShow!;

      return RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 14,
          ),
          children: [
            TextSpan(text: shownItems),
            TextSpan(
              text: ' +$remainingCount more',
              style: TextStyle(
                color: AppColors.appColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Text(
      displayItems.join(', '),
      style: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 14,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Build chips row inside dropdown header
  Widget _buildChipsRow() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: controller.selectedItems.map((item) {
          return Chip(
            label: Text(
              displayText(item),
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            backgroundColor: AppColors.appColor,
            deleteIcon: Icon(
              Icons.close,
              size: 16,
              color: Colors.white,
            ),
            onDeleted: () {
              controller.selectItem(item);
              onSelectionChanged?.call(controller.selectedItems);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            visualDensity: VisualDensity.compact,
          );
        }).toList(),
      ),
    );
  }
}