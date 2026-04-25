import 'package:get/get.dart';

class ServiceProviderMainController extends GetxController {
  RxInt currentIndex = 0.obs;
  final List<String> tabTitles = [
    'Home',
    'Opportunities',
    'Proposals',
    'Assignments',
    'Profile',
  ];

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}