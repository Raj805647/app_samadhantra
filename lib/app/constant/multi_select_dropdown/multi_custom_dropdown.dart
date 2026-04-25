import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectDropdownController<T> extends GetxController {
  final RxList<T> _selectedItems = <T>[].obs;
  final RxBool _isOpen = false.obs;
  final RxBool _isOtherSelected = false.obs;
  final TextEditingController _otherTextController = TextEditingController();

  List<T> get selectedItems => _selectedItems.toList();
  RxList<T> get selectedItemsObs => _selectedItems;
  bool get isOpen => _isOpen.value;
  RxBool get isOpenObs => _isOpen;
  bool get isOtherSelected => _isOtherSelected.value;
  RxBool get isOtherSelectedObs => _isOtherSelected;
  TextEditingController get otherTextController => _otherTextController;

  void toggle() {
    _isOpen.value = !_isOpen.value;
  }

  void toggleOtherSelection() {
    _isOtherSelected.value = !_isOtherSelected.value;
    if (!_isOtherSelected.value) {
      _otherTextController.clear();
    }
    update();
  }

  void selectItem(T item) {
    final isOther = item.toString().toLowerCase() == 'other';
    final isOtherSelected = _selectedItems
        .any((e) => e.toString().toLowerCase() == 'other');

    // Case 1: Tapping on an already selected item → unselect it
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
      update();
      return;
    }

    // Case 2: "Other" is selected → block selecting any other item
    if (isOtherSelected && !isOther) {
      return;
    }

    // Case 3: Selecting "Other" while other items are selected → block
    if (isOther && _selectedItems.isNotEmpty) {
      return;
    }

    // Case 4: Normal selection
    _selectedItems.add(item);
    update();
  }



  void clearSelection() {
    _selectedItems.clear();
    _isOtherSelected.value = false;
    _otherTextController.clear();
    update();
  }

  bool isSelected(T item) {
    return _selectedItems.contains(item);
  }

  void setSelectedItems(List<T> items) {
    _selectedItems.value = items;
    update();
  }

  void setOtherText(String value) {
    _otherTextController.text = value;
  }

  // Get all selected values including custom "Other" value
  List<String> getAllSelectedValues(String Function(T) displayText) {
    final List<String> values = [];

    // Add regular selected items
    for (var item in _selectedItems) {
      values.add(displayText(item));
    }

    // Add "Other" with custom text if selected
    if (_isOtherSelected.value && _otherTextController.text.isNotEmpty) {
      values.add('Other: ${_otherTextController.text}');
    } else if (_isOtherSelected.value) {
      values.add('Other');
    }

    return values;
  }

  // Get only the custom "Other" text if selected
  String? getOtherValue() {
    return _isOtherSelected.value ? _otherTextController.text : null;
  }

  // Check if any item is selected (including "Other")
  bool get hasSelection {
    return _selectedItems.isNotEmpty || _isOtherSelected.value;
  }

  @override
  void onClose() {
    _isOpen.value = false;
    _otherTextController.dispose();
    super.onClose();
  }
}