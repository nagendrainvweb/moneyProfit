class LoanData {
  List<Comparison> comparison;
  List<Overview> overview;
  List<Faq> faq;
  EligibleDocData eligibleDocData;

  LoanData({this.comparison, this.overview, this.faq});

  LoanData.fromJson(Map<String, dynamic> json) {
    comparison = new List<Comparison>();
    overview = new List<Overview>();
    faq = new List<Faq>();
    if (json['comparison'] != null) {
      json['comparison'].forEach((v) {
        comparison.add(new Comparison.fromJson(v));
      });
    }
    if (json['overview'] != null) {
      json['overview'].forEach((v) {
        overview.add(new Overview.fromJson(v));
      });
    }
    if (json['faq'] != null) {
      json['faq'].forEach((v) {
        faq.add(new Faq.fromJson(v));
      });
    }
    eligibleDocData = EligibleDocData.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.comparison != null) {
      data['comparison'] = this.comparison.map((v) => v.toJson()).toList();
    }
    if (this.overview != null) {
      data['overview'] = this.overview.map((v) => v.toJson()).toList();
    }
    if (this.faq != null) {
      data['faq'] = this.faq.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class EligibleDocData {
  List<DocData> salaried;
  List<DocData> selfEmployed;

  EligibleDocData.fromJson(Map<String, dynamic> json) {
    salaried = new List<DocData>();
    selfEmployed = new List<DocData>();
    if (json['salaried'] != null) {
      json['salaried'].forEach((v) {
        salaried.add(new DocData.fromJson(v));
      });
    }
    if (json['self_employed'] != null) {
      json['self_employed'].forEach((v) {
        selfEmployed.add(new DocData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.salaried != null) {
      data['faq'] = this.salaried.map((v) => v.toJson()).toList();
    }
    if (this.selfEmployed != null) {
      data['faq'] = this.selfEmployed.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class DocData {
  String id;
  String title;
  String desc;

  DocData({this.id, this.title, this.desc});

  DocData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    return data;
  }
}

class Comparison {
  String id;
  String bankImg;
  String bankName;
  String intRate;
  String procFees;
  String loanAmt;
  String tenure;

  Comparison(
      {this.id,
      this.bankImg,
      this.bankName,
      this.intRate,
      this.procFees,
      this.loanAmt,
      this.tenure});

  Comparison.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bankImg = json['bank_img'];
    bankName = json['bank_name'];
    intRate = json['int_rate'];
    procFees = json['proc_fees'];
    loanAmt = json['loan_amt'];
    tenure = json['tenure'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bank_img'] = this.bankImg;
    data['bank_name'] = this.bankName;
    data['int_rate'] = this.intRate;
    data['proc_fees'] = this.procFees;
    data['loan_amt'] = this.loanAmt;
    data['tenure'] = this.tenure;
    return data;
  }
}

class Overview {
  String id;
  String title;
  String desc;

  Overview({this.id, this.title, this.desc});

  Overview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['desc'] = this.desc;
    return data;
  }
}

class Faq {
  String id;
  String question;
  String answer;

  Faq({this.id, this.question, this.answer});

  Faq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answer = json['answer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['answer'] = this.answer;
    return data;
  }
}
