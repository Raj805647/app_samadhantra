
class AppConfig {

  static const String baseUrl = "https://api.samadhantra.com/api";
  static const String imageBaseUrl = "https://api.samadhantra.com/";
  static final String mapApiKey= 'AIzaSyCViitAZv9ZguuwectfNKW19XIQ4tEF-XQ';
  static const String imageUrl = "https://turningindia.com/Delivery/uploads/";

  static const String getUserTypeUrl = "/schema/user-types";
  static const String createPaymentOrderApi = "/payment/order";
  static String getUSerTypeFormUrl(String? userType) => "/schema/user-type/$userType";
  static String getrequirementDetailByIdUrl(String? id) => "/requirements/$id";
  static String getTargetActiveList(String? id) => "/requirements/notifications/active/$id";

  static const String loginUrl = "/auth/login";
  static const String postRequirementUrl = "/requirements";
  static const String getMyProfileUrl = "/users/me";
  static const String updateProfileUrl = "/users/me";
  static const String updateProfilePhotoUrl = "/users/me/profile-photo";

  static const String registerUrl = "/delivery/auth/register";
  static const String verifyOtpUrl = "/delivery/auth/verify_otp";
  static const String forgotPasswordUrl = "/delivery/auth/forget_password";
  static const String forgotPasswordOtpUrl = "/delivery/auth/verify_forget_otp";
  static const String resetPasswordUrl = "/delivery/auth/reset_password";
  static  String getContent(String? type) => "/delivery/content/fetchaboutcontent?content_type=$type";
  static const String helpAndSupport = "/delivery/help/fetch_help_support";

  static const String getHomeCategory = "/delivery/home/homepage";
  static const String getSubCategoryByCategory = "/delivery/category/sub/get_sub_category_by_category/";
  static const String getTabProductByCategory = "/delivery/product/get_product_by_category/";
  static const String getSimilarProduct = "/delivery/product/similar/";
  static const String likeUnlikeFavorite = "/delivery/favorite/like_unlike";
  static const String favouriteList = "/delivery/favorite/list";
  static const String addToCart = "/delivery/cart/add_to_cart";
  static const String getCartItems = "/delivery/cart/get_cart";

  static const String getMyOrdersUrl = "/delivery/order/get_my_orders";
  static const String createOrderUrl = "/delivery/order/create";
  static const String getMyAddressUrl = "/delivery/users/address/list";
  static const String addAddressUrl = "/delivery/users/address/add";
  static const String deleteAddressUrl = "/delivery/users/address/delete/";
  static const String setDefaultAddressUrl = "/delivery/users/address/set-default/";
  static const String searchProductUrl = "/delivery/product/get_product?search=";
  static String bidSubmitUrl(String? reqId) => "/api/requirements/$reqId/bid";

  static const String updateRequirement = '/requirements';
  static const String actionFQAList = '/faq';
  static const String actionBlogList = '/blogs';
  static const String actionEventsData = '/events';
  static const String actionEventsCategoryData = '/event-categories';
  static const String actionProviderChatting = '/requirements/chat-sessions/user';
  static const String actionRequesterChatting = '/requirements/shortlist/provider/requesters';
  static const String actionChangePassword = '/auth/update-password';
  static const String actionSendFeedback = '/contact/';
  static const String actionGetDeviceToken = '/users/me/device-tokens';
  static const String actionChatHistory = '/chat/history';
  static const String actionDashboard = '/users/me/dashboard-counters';
  static const String actionActiveAnnouncements = '/requirements/announcements/active';
  static  String actionAssignment(String agreement_id) => '/requirements/agreements/$agreement_id/assignment';
  static  String actionInitialReview(String agreement_id) => '/reviews/agreements/${agreement_id}/reviews/requester/progress';
  static  String actionFinalRequesterReview(String agreement_id) => '/reviews/agreements/${agreement_id}/reviews/requester/final';
  static  String actionFinalProviderReview(String agreement_id) => '/reviews/agreements/${agreement_id}/reviews/provider/final';


}