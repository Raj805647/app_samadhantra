import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_manage_services_screen/service_provider_manage_services_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/service_service_model.dart';

class ServiceProviderManageServicesScreen extends StatelessWidget {
  final ServiceProviderManageServicesController controller =
  Get.find<ServiceProviderManageServicesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
       CustomAppBar(title: "Manage Services",actions: [
         Obx(() {
           if (controller.isSelectionMode.value) {
             return Row(
               children: [
                 IconButton(
                   icon: Icon(Icons.select_all),
                   onPressed: controller.selectAllServices,
                   tooltip: 'Select All',
                 ),
                 IconButton(
                   icon: Icon(Icons.delete_outline),
                   onPressed: controller.deleteSelectedServices,
                   tooltip: 'Delete Selected',
                   color: Colors.red,
                 ),
                 IconButton(
                   icon: Icon(Icons.close),
                   onPressed: controller.toggleSelectionMode,
                   tooltip: 'Cancel Selection',
                 ),
               ],
             );
           }

           return Row(
             children: [
               IconButton(
                 icon: Icon(Icons.search,color: AppColors.white,),
                 onPressed: _showSearchBar,
                 tooltip: 'Search Services',
               ),
               PopupMenuButton(icon: Icon(Icons.more_vert,color: AppColors.white,),
                 itemBuilder: (context) => [
                   PopupMenuItem(
                     child: ListTile(
                       leading: Icon(Icons.sort, color: Colors.blue),
                       title: Text('Sort Services'),
                     ),
                     value: 'sort',
                   ),
                   PopupMenuItem(
                     child: ListTile(
                       leading: Icon(Icons.download, color: Colors.green),
                       title: Text('Export Services'),
                     ),
                     value: 'export',
                   ),
                   PopupMenuItem(
                     child: ListTile(
                       leading: Icon(Icons.filter_alt, color: Colors.orange),
                       title: Text('Filter Options'),
                     ),
                     value: 'filter',
                   ),
                   PopupMenuItem(
                     child: ListTile(
                       leading: Icon(Icons.select_all, color: Colors.purple),
                       title: Text('Select Multiple'),
                     ),
                     value: 'select',
                   ),
                 ],
                 onSelected: (value) {
                   switch (value) {
                     case 'sort':
                       _showSortOptions();
                       break;
                     case 'export':
                       controller.exportServices();
                       break;
                     case 'filter':
                       _showFilterOptions();
                       break;
                     case 'select':
                       controller.toggleSelectionMode();
                       break;
                   }
                 },
               ),
             ],
           );
         }),
       ],),
      // _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Obx(() {
        if (controller.isSelectionMode.value) {
          return Text('${controller.selectedServices.length} selected');
        }
        return Row(
          children: [
            Text('Manage Services'),
            SizedBox(width: 8),
            Obx(() => Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${controller.services.length}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ],
        );
      }),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      Obx(() {
        if (controller.isSelectionMode.value) {
          return Row(
            children: [
              IconButton(
                icon: Icon(Icons.select_all),
                onPressed: controller.selectAllServices,
                tooltip: 'Select All',
              ),
              IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: controller.deleteSelectedServices,
                tooltip: 'Delete Selected',
                color: Colors.red,
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: controller.toggleSelectionMode,
                tooltip: 'Cancel Selection',
              ),
            ],
          );
        }

        return Row(
          children: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: _showSearchBar,
              tooltip: 'Search Services',
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.sort, color: Colors.blue),
                    title: Text('Sort Services'),
                  ),
                  value: 'sort',
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.download, color: Colors.green),
                    title: Text('Export Services'),
                  ),
                  value: 'export',
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.filter_alt, color: Colors.orange),
                    title: Text('Filter Options'),
                  ),
                  value: 'filter',
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.select_all, color: Colors.purple),
                    title: Text('Select Multiple'),
                  ),
                  value: 'select',
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'sort':
                    _showSortOptions();
                    break;
                  case 'export':
                    controller.exportServices();
                    break;
                  case 'filter':
                    _showFilterOptions();
                    break;
                  case 'select':
                    controller.toggleSelectionMode();
                    break;
                }
              },
            ),
          ],
        );
      }),
    ];
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Stats Overview
        _buildStatsOverview(),
        SizedBox(height: 8),

        // Filter Chips
        _buildFilterChips(),
        SizedBox(height: 8),

        // Search Bar (if active)
        Obx(() {
          if (controller.searchQuery.value.isNotEmpty) {
            return _buildSearchBar();
          }
          return SizedBox();
        }),

        // Services List
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return _buildLoadingState();
            }

            final filteredServices = controller.filteredServices;

            if (filteredServices.isEmpty) {
              return _buildEmptyState();
            }

            return _buildServicesList(filteredServices);
          }),
        ),
      ],
    );
  }

  Widget _buildStatsOverview() {
    return Card(
      margin: EdgeInsets.all(12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              value: controller.services.length.toString(),
              label: 'Total',
              icon: Icons.business_center,
              color: Colors.blue,
            ),
            _buildStatItem(
              value: controller.activeServicesCount.toString(),
              label: 'Active',
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            _buildStatItem(
              value: controller.featuredServicesCount.toString(),
              label: 'Featured',
              icon: Icons.star,
              color: Colors.amber,
            ),
            _buildStatItem(
              value: '₹${controller.averageHourlyRate.toStringAsFixed(0)}',
              label: 'Avg. Rate',
              icon: Icons.currency_rupee,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Obx(() => ListView.builder(
        key: ValueKey(controller.selectedFilter.value),
        scrollDirection: Axis.horizontal,
        itemCount: controller.filters.length,
        itemBuilder: (context, index) {
          final filter = controller.filters[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(_getFilterLabel(filter)),
              selected: controller.selectedFilter.value == filter,
              selectedColor: Colors.blue.withOpacity(0.2),
              onSelected: (selected) {
                if (selected) {
                  controller.filterServices(filter);
                }
              },
            ),
          );
        },
      )),
    );
  }

  String _getFilterLabel(ServiceFilter filter) {
    switch (filter) {
      case ServiceFilter.all:
        return 'All';
      case ServiceFilter.active:
        return 'Active';
      case ServiceFilter.inactive:
        return 'Inactive';
      case ServiceFilter.featured:
        return 'Featured';
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.grey[600]),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search services...',
                    border: InputBorder.none,
                  ),
                  controller: TextEditingController(text: controller.searchQuery.value),
                  onChanged: (value) => controller.searchQuery.value = value,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, size: 20),
                onPressed: () {
                  controller.searchQuery.value = '';
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading services...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: () async {
        // await controller.refreshServices();
      },
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: Get.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.business_center_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'No services found',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  controller.searchQuery.value.isNotEmpty
                      ? 'No services match your search'
                      : 'Add your first service to get started',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: controller.addNewService,
                  icon: Icon(Icons.add),
                  label: Text('Add New Service'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServicesList(List<ServiceModel> services) {
    return RefreshIndicator(
      onRefresh: () async {
        // await controller.refreshServices();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceCard(service,context);
        },
      ),
    );
  }

  Widget _buildServiceCard(ServiceModel service,BuildContext context) {
    return Obx(() {
      final isSelected = controller.selectedServices.contains(service.id);
      return Card(
        margin: EdgeInsets.only(bottom: 12),
        elevation: 2,
        color: isSelected ? Colors.blue[50] : null,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            if (controller.isSelectionMode.value) {
              controller.toggleServiceSelection(service.id);
            } else {
              controller.viewServiceDetails(service.id);
            }
          },
          onLongPress: () {
            if (!controller.isSelectionMode.value) {
              controller.toggleSelectionMode();
              controller.toggleServiceSelection(service.id);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service Icon
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(service.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        _getCategoryIcon(service.category),
                        color: _getCategoryColor(service.category),
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),

                    // Service Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (service.isFeatured)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: Colors.amber),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.star, size: 12, color: Colors.amber),
                                      SizedBox(width: 4),
                                      Text(
                                        'Featured',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.amber[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            service.category,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selection Checkbox
                    if (controller.isSelectionMode.value)
                      Checkbox(
                        value: isSelected,
                        onChanged: (value) {
                          controller.toggleServiceSelection(service.id);
                        },
                      ),
                  ],
                ),

                SizedBox(height: 12),

                // Description
                Text(
                  service.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 12),

                // Tags
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: service.tags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: Colors.grey[100],
                      labelStyle: TextStyle(fontSize: 12),
                      padding: EdgeInsets.zero,
                    );
                  }).toList(),
                ),

                SizedBox(height: 12),

                // Footer Row
                Row(
                  children: [
                    // Pricing
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service.formattedHourlyRate,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[700],
                            ),
                          ),
                          Text(
                            'Hourly Rate',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: service.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            service.statusIcon,
                            size: 14,
                            color: service.statusColor,
                          ),
                          SizedBox(width: 4),
                          Text(
                            service.statusText,
                            style: TextStyle(
                              fontSize: 12,
                              color: service.statusColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12),

                    // Action Menu
          Theme(
            data: Theme.of(context).copyWith(
              iconTheme: const IconThemeData(color: Colors.white),
            ),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, size: 20,color: AppColors.white,),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: ListTile(
                    leading: Icon(Icons.edit, color: Colors.blue),
                    title: Text('Edit'),
                  ),
                ),
                PopupMenuItem(
                  value: 'duplicate',
                  child: ListTile(
                    leading: Icon(Icons.content_copy, color: Colors.green),
                    title: Text('Duplicate'),
                  ),
                ),
                PopupMenuItem(
                  value: 'toggle_status',
                  child: ListTile(
                    leading: Icon(
                      service.isActive ? Icons.pause : Icons.play_arrow,
                      color: service.isActive ? Colors.orange : Colors.green,
                    ),
                    title: Text(service.isActive ? 'Deactivate' : 'Activate'),
                  ),
                ),
                PopupMenuItem(
                  value: 'toggle_featured',
                  child: ListTile(
                    leading: Icon(
                      service.isFeatured ? Icons.star_border : Icons.star,
                      color: Colors.amber,
                    ),
                    title: Text(
                      service.isFeatured ? 'Remove Featured' : 'Mark as Featured',
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete'),
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    controller.editService(service.id);
                    break;
                  case 'duplicate':
                    controller.duplicateService(service.id);
                    break;
                  case 'toggle_status':
                    controller.toggleServiceStatus(service.id);
                    break;
                  case 'toggle_featured':
                    controller.toggleFeaturedStatus(service.id);
                    break;
                  case 'delete':
                    controller.deleteService(service.id);
                    break;
                }
              },
            ),
          ),

          ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFloatingActionButton() {
    return Obx(() {
      if (controller.isRefreshing.value) {
        return FloatingActionButton(
          onPressed: null,
          child: CircularProgressIndicator(color: Colors.white),
          backgroundColor: Colors.blue,
        );
      }

      return FloatingActionButton.extended(
        onPressed: controller.addNewService,
        icon: Icon(Icons.add,color: AppColors.white),
        label: Text('Add Service',style: TextStyle(color: AppColors.white),),
        backgroundColor: AppColors.appColor,
      );
    });
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'web development':
        return Icons.web;
      case 'mobile app development':
        return Icons.mobile_friendly;
      case 'ui/ux design':
        return Icons.design_services;
      case 'graphic design':
        return Icons.graphic_eq;
      case 'digital marketing':
        return Icons.trending_up;
      case 'seo':
        return Icons.search;
      case 'content writing':
        return Icons.article;
      case 'video editing':
        return Icons.video_library;
      case 'consulting':
        return Icons.business;
      case 'e-commerce':
        return Icons.shopping_cart;
      case 'cloud services':
        return Icons.cloud;
      default:
        return Icons.business_center;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'web development':
        return Colors.blue;
      case 'mobile app development':
        return Colors.green;
      case 'ui/ux design':
        return Colors.purple;
      case 'graphic design':
        return Colors.orange;
      case 'digital marketing':
        return Colors.teal;
      case 'seo':
        return Colors.indigo;
      case 'content writing':
        return Colors.brown;
      case 'video editing':
        return Colors.red;
      case 'consulting':
        return Colors.cyan;
      case 'e-commerce':
        return Colors.amber;
      case 'cloud services':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  void _showSearchBar() {
    controller.searchQuery.value = '';
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
            Text(
              'Search Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by name, description, or tags...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              autofocus: true,
              onChanged: (value) => controller.searchQuery.value = value,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // Search is already happening via onChanged
                    },
                    child: Text('Search'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          String selectedSort = 'name';

          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Sort Services',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Divider(height: 0),

                RadioListTile(
                  title: const Text('Name (A–Z)'),
                  value: 'name',
                  groupValue: selectedSort,
                  onChanged: (value) {
                    setState(() => selectedSort = value!);
                  },
                ),
                RadioListTile(
                  title: const Text('Hourly Rate (High to Low)'),
                  value: 'rate_high',
                  groupValue: selectedSort,
                  onChanged: (value) {
                    setState(() => selectedSort = value!);
                  },
                ),
                RadioListTile(
                  title: const Text('Hourly Rate (Low to High)'),
                  value: 'rate_low',
                  groupValue: selectedSort,
                  onChanged: (value) {
                    setState(() => selectedSort = value!);
                  },
                ),
                RadioListTile(
                  title: const Text('Newest First'),
                  value: 'newest',
                  groupValue: selectedSort,
                  onChanged: (value) {
                    setState(() => selectedSort = value!);
                  },
                ),
                RadioListTile(
                  title: const Text('Oldest First'),
                  value: 'oldest',
                  groupValue: selectedSort,
                  onChanged: (value) {
                    setState(() => selectedSort = value!);
                  },
                ),

                /// ACTION BUTTONS
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.sortServices(selectedSort);
                            Get.back();
                          },
                          child: const Text('Apply Sort'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }


  void _showFilterOptions() {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: Get.height * 0.85, // 👈 prevents overflow
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView( // 👈 enables scrolling
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Filter Options',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const Divider(height: 0),

              /// CATEGORY
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.categories.map((category) {
                        return FilterChip(
                          label: Text(category),
                          selected: false,
                          onSelected: (_) {},
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// PRICING
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pricing Model',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.pricingModels.map((model) {
                        return FilterChip(
                          label: Text(model),
                          selected: false,
                          onSelected: (_) {},
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /// ACTION BUTTONS
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: Row(
            children: [
              /// RESET BUTTON
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade400),
                    foregroundColor: Colors.grey.shade700,
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text('Reset'),
                ),
              ),

              const SizedBox(width: 12),

              /// APPLY BUTTON
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    backgroundColor: AppColors.appColor,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text('Apply Filters'),
                ),
              ),
            ],
          ),
        ),

        ],
          ),
        ),
      ),
      isScrollControlled: true, // 👈 IMPORTANT
    );
  }

}