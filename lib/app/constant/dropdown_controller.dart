import 'package:get/get.dart';

class DropdownController<T> extends GetxController {
  Rx<T?> selectedItem = Rx<T?>(null);
  RxBool isOpen = false.obs;

  void selectItem(T item) {
    selectedItem.value = item;
    isOpen.value = false;
  }

  void toggle() => isOpen.toggle();
}