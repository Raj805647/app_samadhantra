import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/utils/app_config.dart';

class PlacePrediction {
  final String placeId;
  final String mainText;
  final String secondaryText;

  PlacePrediction({
    required this.placeId,
    required this.mainText,
    required this.secondaryText,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      placeId: json['place_id'],
      mainText: json['structured_formatting']['main_text'],
      secondaryText: json['structured_formatting']['secondary_text'] ?? '',
    );
  }
}

class PlaceDetail {
  final String address;
  final double lat;
  final double lng;
  final String city;      // Add this
  final String state;     // Add this

  PlaceDetail({
    required this.address,
    required this.lat,
    required this.lng,
    required this.city,   // Add this
    required this.state,  // Add this
  });
}

class MapController extends GetxController {
  static MapController get to => Get.find();
  final String apiKey = AppConfig.mapApiKey; // Replace with your API key
  var selectedCountryCode = 'IN'.obs; // Store only country code
  var predictions = <PlacePrediction>[].obs;
    var selectedPlace = Rx<PlaceDetail?>(null);
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  // final signUpController = Get.find<>();

  // Static list of supported country codes
  final List<String> supportedCountries = ['IN', 'US', 'GB', 'AU', 'CA', 'AE', 'SA', 'SG', 'MY', 'JP', 'KR'];

  void updateCountryCode(String countryCode) {

    // Validate if the country code is supported, otherwise default to IN
    if (supportedCountries.contains(countryCode)) {
      selectedCountryCode.value = countryCode;
    } else {
      selectedCountryCode.value = 'IN'; // Default to India
      Get.snackbar(
        '⚠️ Country Not Supported',
        'Defaulting to India (IN)',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }

    // Re-search if there's a current query
    if (searchQuery.value.length > 2) {
      searchPlaces(searchQuery.value);
    }

  }

  Future<void> searchPlaces(String input) async {
    if (input.isEmpty) {
      predictions.clear();
      return;
    }

    isLoading.value = true;

    try {
      // Ensure country code is valid, otherwise default to IN
      final validCountryCode = supportedCountries.contains(selectedCountryCode.value)
          ? selectedCountryCode.value
          : 'IN';

      // Properly encode the input to handle special characters
      final encodedInput = Uri.encodeComponent(input);
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$encodedInput&key=$apiKey&components=country:$validCountryCode'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          predictions.value = (data['predictions'] as List)
              .map((json) => PlacePrediction.fromJson(json))
              .toList();
        } else {
          predictions.clear();
          if (data['status'] != 'ZERO_RESULTS') {
            Get.snackbar('Error', 'API Error: ${data['status']}');
          }
        }
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      predictions.clear();
      Get.snackbar('Error', 'Failed to search places: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getCountryName(String countryCode) {
    final countryNames = {
      'IN': 'India',
      'US': 'United States',
      'GB': 'United Kingdom',
      'AU': 'Australia',
      'CA': 'Canada',
      'AE': 'United Arab Emirates',
      'SA': 'Saudi Arabia',
      'SG': 'Singapore',
      'MY': 'Malaysia',
      'JP': 'Japan',
      'KR': 'South Korea',
    };
    return countryNames[countryCode] ?? 'India';
  }

  // Get current country info for display
  String getCurrentCountryInfo() {
    return '${getCountryName(selectedCountryCode.value)} (${selectedCountryCode.value})';
  }

  // Get place details
  Future<void> getPlaceDetails(String placeId) async {
    isLoading.value = true;

    try {
      final encodedPlaceId = Uri.encodeComponent(placeId);
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$encodedPlaceId&key=$apiKey&fields=name,formatted_address,geometry,address_components'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final result = data['result'];

          // Extract city and state from address components
          String city = '';
          String state = '';

          final addressComponents = result['address_components'];
          if (addressComponents != null) {
            for (var component in addressComponents) {
              final types = List<String>.from(component['types']);

              if (types.contains('locality') || types.contains('sublocality')) {
                city = component['long_name'];
              } else if (types.contains('administrative_area_level_1')) {
                state = component['long_name'];
              } else if (types.contains('postal_town') && city.isEmpty) {
                city = component['long_name'];
              }
            }
          }

          // If city is still empty, try to extract from formatted address
          if (city.isEmpty && result['formatted_address'] != null) {
            city = _extractCityFromAddress(result['formatted_address']);
          }

          selectedPlace.value = PlaceDetail(
            address: result['formatted_address'],
            lat: result['geometry']['location']['lat'],
            lng: result['geometry']['location']['lng'],
            city: city,      // Add this
            state: state,    // Add this
          );

          print("166 ${selectedPlace.value?.address.toString()}");

          // Clear predictions after selection
          predictions.clear();
          searchQuery.value = '';
        } else {
          Get.snackbar('Error', 'Failed to get place details: ${data['status']}');
        }
      } else {
        throw Exception('Failed to load place details');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to get place details: $e');
    } finally {
      isLoading.value = false;
    }
  }

// Helper method to extract city from formatted address if address_components doesn't provide it
  String _extractCityFromAddress(String address) {
    try {
      // Common patterns for extracting city
      final parts = address.split(',');
      if (parts.length > 1) {
        // Usually city is the second last or third last part
        // Example: "123 Street, City, State, Country"
        return parts[parts.length - 3].trim();
      }
    } catch (e) {
      print('Error extracting city: $e');
    }
    return '';
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    predictions.clear();
  }
}