import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_reviews_screen/service_provider_reviews_screen_controller.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class ServiceProviderReviewsScreen extends StatelessWidget {
  final ServiceProviderReviewsController controller = Get.put(ServiceProviderReviewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Review & Ratings"),
            body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Rating
              _buildOverallRating(),
              SizedBox(height: 24),

              // Rating Distribution
              _buildRatingDistribution(),
              SizedBox(height: 24),

              // Recent Reviews
              _buildRecentReviews(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildOverallRating() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.averageRating.value.toStringAsFixed(1),
                  style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          size: 20,
                          color: index < controller.averageRating.value.floor()
                              ? Colors.amber
                              : Colors.grey[300],
                        );
                      }),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${controller.totalReviews.value} reviews',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Based on ${controller.totalReviews.value} customer reviews',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingDistribution() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rating Distribution',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ..._buildRatingBars(),
      ],
    );
  }

  List<Widget> _buildRatingBars() {
    List<Widget> bars = [];

    for (int rating = 5; rating >= 1; rating--) {
      final count = controller.ratingDistribution[rating] ?? 0;
      final percentage = controller.totalReviews.value > 0
          ? (count / controller.totalReviews.value * 100)
          : 0;

      bars.add(
        Column(
          children: [
            Row(
              children: [
                Text(
                  '$rating',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.star, size: 16, color: Colors.amber),
                SizedBox(width: 16),
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey[200],
                    color: Colors.amber,
                  ),
                ),
                SizedBox(width: 16),
                Text('${percentage.toStringAsFixed(0)}%'),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () => _viewReviewsByRating(rating),
                  child: Text('($count)'),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      );
    }

    return bars;
  }

  Widget _buildRecentReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Reviews',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => _viewAllReviews(),
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 16),
        ...controller.reviews.take(5).map((review) {
          return _buildReviewCard(review);
        }).toList(),
      ],
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review['clientName'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              size: 16,
                              color: index < review['rating']
                                  ? Colors.amber
                                  : Colors.grey[300],
                            );
                          }),
                          SizedBox(width: 8),
                          Text(
                            review['date'],
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              review['project'],
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 8),
            Text(review['comment']),
            SizedBox(height: 12),
            if (review['response'] != null && review['response'].isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Response',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(review['response']),
                    SizedBox(height: 4),
                    Text(
                      review['responseDate'] ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 12),
            if (review['response'] == null || review['response'].isEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _addResponse(review['id']),
                  child: Text('Add Response'),
                ),
              )
            else
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => _editResponse(review['id']),
                  child: Text('Edit Response'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _viewReviewsByRating(int rating) {
    final filteredReviews = controller.getReviewsByRating(rating);

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              '$rating Star Reviews',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: filteredReviews.isEmpty
                  ? Center(
                child: Text('No reviews with $rating stars'),
              )
                  : ListView.builder(
                itemCount: filteredReviews.length,
                itemBuilder: (context, index) {
                  return _buildReviewCard(filteredReviews[index]);
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _viewAllReviews() {
    Get.toNamed('/service-provider/all-reviews');
  }

  void _addResponse(String reviewId) {
    String response = '';

    Get.dialog(
      AlertDialog(
        title: Text('Add Response'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Type your response here...',
            border: OutlineInputBorder(),
          ),
          maxLines: 4,
          onChanged: (value) => response = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (response.isNotEmpty) {
                controller.addResponse(reviewId, response);
                Get.back();
              }
            },
            child: Text('Post Response'),
          ),
        ],
      ),
    );
  }

  void _editResponse(String reviewId) {
    final review = controller.reviews.firstWhere((r) => r['id'] == reviewId);
    String response = review['response'] ?? '';

    Get.dialog(
      AlertDialog(
        title: Text('Edit Response'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Type your response here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              controller: TextEditingController(text: response),
              onChanged: (value) => response = value,
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: 'Delete Response',
                    middleText: 'Are you sure you want to delete this response?',
                    textConfirm: 'Delete',
                    textCancel: 'Cancel',
                    onConfirm: () {
                      controller.deleteResponse(reviewId);
                      Get.back();
                      Get.back();
                    },
                  );
                },
                child: Text(
                  'Delete Response',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (response.isNotEmpty) {
                controller.addResponse(reviewId, response);
                Get.back();
              }
            },
            child: Text('Update Response'),
          ),
        ],
      ),
    );
  }
}