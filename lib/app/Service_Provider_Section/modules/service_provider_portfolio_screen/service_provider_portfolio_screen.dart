import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_portfolio_screen/service_provider_portfolio_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class ServiceProviderPortfolioScreen extends StatelessWidget {
  final ServiceProviderPortfolioController controller = Get.put(ServiceProviderPortfolioController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My portfolio",actions: [
        IconButton(
          icon: Icon(Icons.add,color: AppColors.white,),
          onPressed: () => _addPortfolioItem(),
        ),
      ],),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Category Filter
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.categories.length,
                itemBuilder: (context, index) {
                  final category = controller.categories[index];
                  return Obx(() => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: controller.selectedCategory.value == category,
                      onSelected: (selected) {
                        controller.selectedCategory.value = category;
                      },
                    ),
                  ));
                },
              ),
            ),

            // Portfolio Items
            Expanded(
              child: _buildPortfolioGrid(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildPortfolioGrid() {
    final filteredItems = controller.filteredPortfolio;

    if (filteredItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.work_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No portfolio items yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Add your work to showcase to clients',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
           AppButton(title: "Add Portfolio Item",onPressed: () => _addPortfolioItem(),),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: filteredItems.length,
      itemBuilder: (context, index) {
        final item = filteredItems[index];
        return _buildPortfolioCard(item);
      },
    );
  }

  Widget _buildPortfolioCard(Map<String, dynamic> item) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image/Thumbnail
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: item['images'] != null && item['images'].isNotEmpty
                  ? ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                child: Image.asset(
                  item['images'][0],
                  fit: BoxFit.cover,
                ),
              )
                  : Center(
                child: Icon(
                  Icons.work,
                  size: 50,
                  color: Colors.blue[200],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (item['featured'] == true)
                      Icon(Icons.star, size: 16, color: Colors.amber),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  item['category'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      label: Text(item['client'] ?? 'Client'),
                      backgroundColor: Colors.grey[100],
                      labelStyle: TextStyle(fontSize: 10),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.more_vert, size: 20),
                      onPressed: () => _showPortfolioOptions(item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addPortfolioItem() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add Portfolio Item',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Project Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Client Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: controller.categories
                    .where((cat) => cat != 'All')
                    .map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Technologies Used (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Results/Achievements',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add portfolio item
                  Get.back();
                },
                child: Text('Add to Portfolio'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPortfolioOptions(Map<String, dynamic> item) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.visibility),
              title: Text('View Details'),
              onTap: () {
                Get.back();
                _viewPortfolioDetails(item);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Get.back();
                _editPortfolioItem(item);
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: item['featured'] == true ? Colors.amber : Colors.grey),
              title: Text(item['featured'] == true ? 'Remove Featured' : 'Mark as Featured'),
              onTap: () {
                Get.back();
                controller.toggleFeatured(item['id']);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                controller.deletePortfolioItem(item['id']);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewPortfolioDetails(Map<String, dynamic> item) {
    Get.dialog(
      AlertDialog(
        title: Text(item['title']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item['images'] != null && item['images'].isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      item['images'][0],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              SizedBox(height: 16),
              Text(
                'Client: ${item['client']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Category: ${item['category']}',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(item['description']),
              SizedBox(height: 16),
              if (item['technologies'] != null && item['technologies'].isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Technologies:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: (item['technologies'] as List).map((tech) {
                        return Chip(
                          label: Text(tech),
                          backgroundColor: Colors.blue[50],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              if (item['results'] != null && item['results'].isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Results:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(item['results']),
                  ],
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editPortfolioItem(Map<String, dynamic> item) {
    // Implement edit functionality
    Get.snackbar('Info', 'Edit functionality coming soon');
  }
}