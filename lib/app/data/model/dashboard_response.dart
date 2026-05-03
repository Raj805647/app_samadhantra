class DashboardResponse {
  DashboardResponse({
      this.status, 
      this.message, 
      this.data,});

  DashboardResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DashBoardData.fromJson(json['data']) : null;
  }
  bool? status;
  String? message;
  DashBoardData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

class DashBoardData {
  DashBoardData({
      this.basicCounters, 
      this.progressCounters,});

  DashBoardData.fromJson(dynamic json) {
    basicCounters = json['basicCounters'] != null ? BasicCounters.fromJson(json['basicCounters']) : null;
    progressCounters = json['progressCounters'] != null ? ProgressCounters.fromJson(json['progressCounters']) : null;
  }
  BasicCounters? basicCounters;
  ProgressCounters? progressCounters;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (basicCounters != null) {
      map['basicCounters'] = basicCounters?.toJson();
    }
    if (progressCounters != null) {
      map['progressCounters'] = progressCounters?.toJson();
    }
    return map;
  }

}

class ProgressCounters {
  ProgressCounters({
      this.requirementsCreatedToday, 
      this.requirementsCreatedThisWeek, 
      this.requirementsCreatedThisMonth, 
      this.requirementsCreatedThisYear, 
      this.bidsSubmittedToday, 
      this.bidsSubmittedThisMonth, 
      this.agreementsSignedThisMonth,});

  ProgressCounters.fromJson(dynamic json) {
    requirementsCreatedToday = json['requirementsCreatedToday'];
    requirementsCreatedThisWeek = json['requirementsCreatedThisWeek'];
    requirementsCreatedThisMonth = json['requirementsCreatedThisMonth'];
    requirementsCreatedThisYear = json['requirementsCreatedThisYear'];
    bidsSubmittedToday = json['bidsSubmittedToday'];
    bidsSubmittedThisMonth = json['bidsSubmittedThisMonth'];
    agreementsSignedThisMonth = json['agreementsSignedThisMonth'];
  }
  int? requirementsCreatedToday;
  int? requirementsCreatedThisWeek;
  int? requirementsCreatedThisMonth;
  int? requirementsCreatedThisYear;
  int? bidsSubmittedToday;
  int? bidsSubmittedThisMonth;
  int? agreementsSignedThisMonth;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['requirementsCreatedToday'] = requirementsCreatedToday;
    map['requirementsCreatedThisWeek'] = requirementsCreatedThisWeek;
    map['requirementsCreatedThisMonth'] = requirementsCreatedThisMonth;
    map['requirementsCreatedThisYear'] = requirementsCreatedThisYear;
    map['bidsSubmittedToday'] = bidsSubmittedToday;
    map['bidsSubmittedThisMonth'] = bidsSubmittedThisMonth;
    map['agreementsSignedThisMonth'] = agreementsSignedThisMonth;
    return map;
  }

}

class BasicCounters {
  BasicCounters({
      this.totalRequirements, 
      this.activeRequirements, 
      this.closedRequirements, 
      this.totalBidsSubmitted, 
      this.shortlistedProviders, 
      this.totalAgreements, 
      this.activeChats, 
      this.unreadNotifications,});

  BasicCounters.fromJson(dynamic json) {
    totalRequirements = json['totalRequirements'];
    activeRequirements = json['activeRequirements'];
    closedRequirements = json['closedRequirements'];
    totalBidsSubmitted = json['totalBidsSubmitted'];
    shortlistedProviders = json['shortlistedProviders'];
    totalAgreements = json['totalAgreements'];
    activeChats = json['activeChats'];
    unreadNotifications = json['unreadNotifications'];
  }
  int? totalRequirements;
  int? activeRequirements;
  int? closedRequirements;
  int? totalBidsSubmitted;
  int? shortlistedProviders;
  int? totalAgreements;
  int? activeChats;
  int? unreadNotifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalRequirements'] = totalRequirements;
    map['activeRequirements'] = activeRequirements;
    map['closedRequirements'] = closedRequirements;
    map['totalBidsSubmitted'] = totalBidsSubmitted;
    map['shortlistedProviders'] = shortlistedProviders;
    map['totalAgreements'] = totalAgreements;
    map['activeChats'] = activeChats;
    map['unreadNotifications'] = unreadNotifications;
    return map;
  }

}