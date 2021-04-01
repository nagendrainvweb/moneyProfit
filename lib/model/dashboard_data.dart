class DashboardData {
  List<Testimonial> testimonial;
  List<Banner> banner;

  DashboardData({this.testimonial, this.banner});

  DashboardData.fromJson(Map<String, dynamic> json) {
    if (json['testimonial'] != null) {
      testimonial = new List<Testimonial>();
      json['testimonial'].forEach((v) {
        testimonial.add(new Testimonial.fromJson(v));
      });
    }
    if (json['banner'] != null) {
      banner = new List<Banner>();
      json['banner'].forEach((v) {
        banner.add(new Banner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.testimonial != null) {
      data['testimonial'] = this.testimonial.map((v) => v.toJson()).toList();
    }
    if (this.banner != null) {
      data['banner'] = this.banner.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Testimonial {
  String id;
  String userImg;
  String starImg;
  String name;
  String desc;

  Testimonial({this.id, this.userImg, this.starImg, this.name, this.desc});

  Testimonial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userImg = json['user_img'];
    starImg = json['star_img'];
    name = json['name'];
    desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_img'] = this.userImg;
    data['star_img'] = this.starImg;
    data['name'] = this.name;
    data['desc'] = this.desc;
    return data;
  }
}

class Banner {
  String id;
  String bannerImg;

  Banner({this.id, this.bannerImg});

  Banner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bannerImg = json['banner_img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['banner_img'] = this.bannerImg;
    return data;
  }
}
