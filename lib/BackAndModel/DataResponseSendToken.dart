

class DataResponseSendToken {
  String? sms;
  int? native;
  String? place;
  int? splash;
  List<String>? allow;
  List<Links>? links;
  Links? button;

  DataResponseSendToken(
      {this.sms,
        this.native,
        this.place,
        this.splash,
        this.allow,
        this.links,
        this.button});

  DataResponseSendToken.fromJson(Map<String, dynamic> json) {
    sms = json['Sms'];
    native = json['Native'];
    place = json['Place'];
    splash = json['Splash'];
    allow = json['Allow'].cast<String>();
    if (json['Links'] != null) {
      links = [];//new List<Links>();
      json['Links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    button = json['Button'] != null ? new Links.fromJson(json['Button']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Sms'] = this.sms;
    data['Native'] = this.native;
    data['Place'] = this.place;
    data['Splash'] = this.splash;
    data['Allow'] = this.allow;
    if (this.links != null) {
      data['Links'] = this.links!.map((v) => v.toJson()).toList();
    }
    if (this.button != null) {
      data['Button'] = this.button!.toJson();
    }
    return data;
  }
}

class Links {
  String? text;
  String? url;

  Links({this.text, this.url});

  Links.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['url'] = this.url;
    return data;
  }
}
