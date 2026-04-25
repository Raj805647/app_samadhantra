class MyAgreementResponse {
  MyAgreementResponse({
      bool? status, 
      String? message, 
      List<AgreementData>? data,}){
    _status = status;
    _message = message;
    _data = data;
}

  MyAgreementResponse.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(AgreementData.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<AgreementData>? _data;
MyAgreementResponse copyWith({  bool? status,
  String? message,
  List<AgreementData>? data,
}) => MyAgreementResponse(  status: status ?? _status,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get status => _status;
  String? get message => _message;
  List<AgreementData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class AgreementData {
  AgreementData({
      String? id, 
      String? agreementNumber, 
      String? requirementId, 
      String? requirementBidId, 
      String? requesterUserId, 
      String? providerUserId, 
      String? agreementDate, 
      String? scopeDescription, 
      String? specificationsDeliverables, 
      String? deliveryLocation, 
      double? contractAmount,
      double? applicableTaxes,
      double? totalPayableAmount,
      double? milestone1Amount,
      double? milestone2Amount,
      double? milestone3Amount,
    String? milestone1Timeline,
      String? milestone2Timeline, 
      String? milestone3Timeline, 
      String? deliveryStartDate, 
      String? expectedCompletionDate, 
      String? jurisdictionCourt, 
      String? requesterSignature, 
      dynamic providerSignature, 
      String? facilitatorSignatory, 
      String? status, 
      dynamic signedAt, 
      String? createdAt,}){
    _id = id;
    _agreementNumber = agreementNumber;
    _requirementId = requirementId;
    _requirementBidId = requirementBidId;
    _requesterUserId = requesterUserId;
    _providerUserId = providerUserId;
    _agreementDate = agreementDate;
    _scopeDescription = scopeDescription;
    _specificationsDeliverables = specificationsDeliverables;
    _deliveryLocation = deliveryLocation;
    _contractAmount = contractAmount;
    _applicableTaxes = applicableTaxes;
    _totalPayableAmount = totalPayableAmount;
    _milestone1Amount = milestone1Amount;
    _milestone2Amount = milestone2Amount;
    _milestone3Amount = milestone3Amount;
    _milestone1Timeline = milestone1Timeline;
    _milestone2Timeline = milestone2Timeline;
    _milestone3Timeline = milestone3Timeline;
    _deliveryStartDate = deliveryStartDate;
    _expectedCompletionDate = expectedCompletionDate;
    _jurisdictionCourt = jurisdictionCourt;
    _requesterSignature = requesterSignature;
    _providerSignature = providerSignature;
    _facilitatorSignatory = facilitatorSignatory;
    _status = status;
    _signedAt = signedAt;
    _createdAt = createdAt;
}

  AgreementData.fromJson(dynamic json) {
    _id = json['id'];
    _agreementNumber = json['agreement_number'];
    _requirementId = json['requirement_id'];
    _requirementBidId = json['requirement_bid_id'];
    _requesterUserId = json['requester_user_id'];
    _providerUserId = json['provider_user_id'];
    _agreementDate = json['agreement_date'];
    _scopeDescription = json['scope_description'];
    _specificationsDeliverables = json['specifications_deliverables'];
    _deliveryLocation = json['delivery_location'];
    _contractAmount = json['contract_amount'];
    _applicableTaxes = json['applicable_taxes'];
    _totalPayableAmount = json['total_payable_amount'];
    _milestone1Amount = json['milestone_1_amount'];
    _milestone2Amount = json['milestone_2_amount'];
    _milestone3Amount = json['milestone_3_amount'];
    _milestone1Timeline = json['milestone_1_timeline'];
    _milestone2Timeline = json['milestone_2_timeline'];
    _milestone3Timeline = json['milestone_3_timeline'];
    _deliveryStartDate = json['delivery_start_date'];
    _expectedCompletionDate = json['expected_completion_date'];
    _jurisdictionCourt = json['jurisdiction_court'];
    _requesterSignature = json['requester_signature'];
    _providerSignature = json['provider_signature'];
    _facilitatorSignatory = json['facilitator_signatory'];
    _status = json['status'];
    _signedAt = json['signed_at'];
    _createdAt = json['created_at'];
  }
  String? _id;
  String? _agreementNumber;
  String? _requirementId;
  String? _requirementBidId;
  String? _requesterUserId;
  String? _providerUserId;
  String? _agreementDate;
  String? _scopeDescription;
  String? _specificationsDeliverables;
  String? _deliveryLocation;
  double? _contractAmount;
  double? _applicableTaxes;
  double? _totalPayableAmount;
  double? _milestone1Amount;
  double? _milestone2Amount;
  double? _milestone3Amount;
  String? _milestone1Timeline;
  String? _milestone2Timeline;
  String? _milestone3Timeline;
  String? _deliveryStartDate;
  String? _expectedCompletionDate;
  String? _jurisdictionCourt;
  String? _requesterSignature;
  dynamic _providerSignature;
  String? _facilitatorSignatory;
  String? _status;
  dynamic _signedAt;
  String? _createdAt;
AgreementData copyWith({  String? id,
  String? agreementNumber,
  String? requirementId,
  String? requirementBidId,
  String? requesterUserId,
  String? providerUserId,
  String? agreementDate,
  String? scopeDescription,
  String? specificationsDeliverables,
  String? deliveryLocation,
  double? contractAmount,
  double? applicableTaxes,
  double? totalPayableAmount,
  double? milestone1Amount,
  double? milestone2Amount,
  double? milestone3Amount,
  String? milestone1Timeline,
  String? milestone2Timeline,
  String? milestone3Timeline,
  String? deliveryStartDate,
  String? expectedCompletionDate,
  String? jurisdictionCourt,
  String? requesterSignature,
  dynamic providerSignature,
  String? facilitatorSignatory,
  String? status,
  dynamic signedAt,
  String? createdAt,
}) => AgreementData(  id: id ?? _id,
  agreementNumber: agreementNumber ?? _agreementNumber,
  requirementId: requirementId ?? _requirementId,
  requirementBidId: requirementBidId ?? _requirementBidId,
  requesterUserId: requesterUserId ?? _requesterUserId,
  providerUserId: providerUserId ?? _providerUserId,
  agreementDate: agreementDate ?? _agreementDate,
  scopeDescription: scopeDescription ?? _scopeDescription,
  specificationsDeliverables: specificationsDeliverables ?? _specificationsDeliverables,
  deliveryLocation: deliveryLocation ?? _deliveryLocation,
  contractAmount: contractAmount ?? _contractAmount,
  applicableTaxes: applicableTaxes ?? _applicableTaxes,
  totalPayableAmount: totalPayableAmount ?? _totalPayableAmount,
  milestone1Amount: milestone1Amount ?? _milestone1Amount,
  milestone2Amount: milestone2Amount ?? _milestone2Amount,
  milestone3Amount: milestone3Amount ?? _milestone3Amount,
  milestone1Timeline: milestone1Timeline ?? _milestone1Timeline,
  milestone2Timeline: milestone2Timeline ?? _milestone2Timeline,
  milestone3Timeline: milestone3Timeline ?? _milestone3Timeline,
  deliveryStartDate: deliveryStartDate ?? _deliveryStartDate,
  expectedCompletionDate: expectedCompletionDate ?? _expectedCompletionDate,
  jurisdictionCourt: jurisdictionCourt ?? _jurisdictionCourt,
  requesterSignature: requesterSignature ?? _requesterSignature,
  providerSignature: providerSignature ?? _providerSignature,
  facilitatorSignatory: facilitatorSignatory ?? _facilitatorSignatory,
  status: status ?? _status,
  signedAt: signedAt ?? _signedAt,
  createdAt: createdAt ?? _createdAt,
);
  String? get id => _id;
  String? get agreementNumber => _agreementNumber;
  String? get requirementId => _requirementId;
  String? get requirementBidId => _requirementBidId;
  String? get requesterUserId => _requesterUserId;
  String? get providerUserId => _providerUserId;
  String? get agreementDate => _agreementDate;
  String? get scopeDescription => _scopeDescription;
  String? get specificationsDeliverables => _specificationsDeliverables;
  String? get deliveryLocation => _deliveryLocation;
  double? get contractAmount => _contractAmount;
  double? get applicableTaxes => _applicableTaxes;
  double? get totalPayableAmount => _totalPayableAmount;
  double? get milestone1Amount => _milestone1Amount;
  double? get milestone2Amount => _milestone2Amount;
  double? get milestone3Amount => _milestone3Amount;
  String? get milestone1Timeline => _milestone1Timeline;
  String? get milestone2Timeline => _milestone2Timeline;
  String? get milestone3Timeline => _milestone3Timeline;
  String? get deliveryStartDate => _deliveryStartDate;
  String? get expectedCompletionDate => _expectedCompletionDate;
  String? get jurisdictionCourt => _jurisdictionCourt;
  String? get requesterSignature => _requesterSignature;
  dynamic get providerSignature => _providerSignature;
  String? get facilitatorSignatory => _facilitatorSignatory;
  String? get status => _status;
  dynamic get signedAt => _signedAt;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['agreement_number'] = _agreementNumber;
    map['requirement_id'] = _requirementId;
    map['requirement_bid_id'] = _requirementBidId;
    map['requester_user_id'] = _requesterUserId;
    map['provider_user_id'] = _providerUserId;
    map['agreement_date'] = _agreementDate;
    map['scope_description'] = _scopeDescription;
    map['specifications_deliverables'] = _specificationsDeliverables;
    map['delivery_location'] = _deliveryLocation;
    map['contract_amount'] = _contractAmount;
    map['applicable_taxes'] = _applicableTaxes;
    map['total_payable_amount'] = _totalPayableAmount;
    map['milestone_1_amount'] = _milestone1Amount;
    map['milestone_2_amount'] = _milestone2Amount;
    map['milestone_3_amount'] = _milestone3Amount;
    map['milestone_1_timeline'] = _milestone1Timeline;
    map['milestone_2_timeline'] = _milestone2Timeline;
    map['milestone_3_timeline'] = _milestone3Timeline;
    map['delivery_start_date'] = _deliveryStartDate;
    map['expected_completion_date'] = _expectedCompletionDate;
    map['jurisdiction_court'] = _jurisdictionCourt;
    map['requester_signature'] = _requesterSignature;
    map['provider_signature'] = _providerSignature;
    map['facilitator_signatory'] = _facilitatorSignatory;
    map['status'] = _status;
    map['signed_at'] = _signedAt;
    map['created_at'] = _createdAt;
    return map;
  }

}