class CrifScoreData {
  String id;
  String crifResponeDataId;
  String moneyUserId;
  String scoreType;
  String scoreValue;
  String scoreFactors;
  String scoreComments;
  String addedonDate;
  String addedonTime;
  String updatedonDate;
  String updatedonTime;

  CrifScoreData(
      {this.id,
      this.crifResponeDataId,
      this.moneyUserId,
      this.scoreType,
      this.scoreValue,
      this.scoreFactors,
      this.scoreComments,
      this.addedonDate,
      this.addedonTime,
      this.updatedonDate,
      this.updatedonTime});

  CrifScoreData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    crifResponeDataId = json['crif_respone_data_id'];
    moneyUserId = json['money_user_id'];
    scoreType = json['score_type'];
    scoreValue = json['score_value'];
    scoreFactors = json['score_factors'];
    scoreComments = json['score_comments'];
    addedonDate = json['addedon_date'];
    addedonTime = json['addedon_time'];
    updatedonDate = json['updatedon_date'];
    updatedonTime = json['updatedon_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['crif_respone_data_id'] = this.crifResponeDataId;
    data['money_user_id'] = this.moneyUserId;
    data['score_type'] = this.scoreType;
    data['score_value'] = this.scoreValue;
    data['score_factors'] = this.scoreFactors;
    data['score_comments'] = this.scoreComments;
    data['addedon_date'] = this.addedonDate;
    data['addedon_time'] = this.addedonTime;
    data['updatedon_date'] = this.updatedonDate;
    data['updatedon_time'] = this.updatedonTime;
    return data;
  }
}