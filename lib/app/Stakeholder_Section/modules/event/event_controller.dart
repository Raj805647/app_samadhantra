import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/data/model/events_category_response.dart';
import 'package:samadhantra/app/data/model/events_response.dart';
import 'package:samadhantra/app/utils/app_config.dart';

class EventController extends GetxController {
  var selectedCategoryId = Rxn<String>();

  /// 📌 Data Lists
  RxList<EventsCategoryData> categories = <EventsCategoryData>[].obs;
  RxList<EventsData> events = <EventsData>[].obs;

  /// 📌 Loading States
  var isCategoryLoading = false.obs;
  var isEventLoading = false.obs;

  /// 📌 Pagination (Categories)
  int categoryPage = 1;
  final int limit = 10;
  var hasMoreCategories = true.obs;

  /// 📌 Pagination (Events)
  int eventPage = 1;
  var hasMoreEvents = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchEvents();
  }

  /// ============================================
  /// 📌 CATEGORY PAGINATION
  /// ============================================
  Future<void> fetchCategories({bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMoreCategories.value) return;
      categoryPage++;
    } else {
      categoryPage = 1;
      categories.clear();
    }

    try {
      isCategoryLoading(true);

      final url =
          "${AppConfig.baseUrl}/${AppConfig.actionEventsCategoryData}"
          "?skip=${(categoryPage - 1) * limit}&limit=$limit";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List newData = data['data'] ?? [];

        final List<EventsCategoryData> list = newData
            .map((e) => EventsCategoryData.fromJson(e))
            .toList();

        if (list.length < limit) {
          hasMoreCategories(false);
        }

        categories.addAll(list);
      }
    } catch (e) {
      print("Category Exception: $e");
    } finally {
      isCategoryLoading(false);
    }
  }

  /// ============================================
  /// 📌 EVENT PAGINATION
  /// ============================================
  Future<void> fetchEvents({String? categoryId, bool loadMore = false}) async {
    if (loadMore) {
      if (!hasMoreEvents.value) return;
      eventPage++;
    } else {
      eventPage = 1;
      events.clear();
    }

    try {
      isEventLoading(true);

      final url =
          "${AppConfig.baseUrl}/${AppConfig.actionEventsData}"
          "?skip=${(eventPage - 1) * limit}&limit=$limit";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List newData = data['data'] ?? [];

        final List<EventsData> list = newData
            .map((e) => EventsData.fromJson(e))
            .toList();

        if (list.length < limit) {
          hasMoreEvents(false);
        }

        events.addAll(list);
      }
    } catch (e) {
      print("Event Exception: $e");
    } finally {
      isEventLoading(false);
    }
  }
}