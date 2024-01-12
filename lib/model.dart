class Thirukural {
  List<Kural>? kural;
  String? repo;

  Thirukural({this.kural, this.repo});

  Thirukural.fromJson(Map<String, dynamic> json) {
    if (json['kural'] != null) {
      kural = <Kural>[];
      json['kural'].forEach((v) {
        kural!.add(new Kural.fromJson(v));
      });
    }
    repo = json['repo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.kural != null) {
      data['kural'] = this.kural!.map((v) => v.toJson()).toList();
    }
    data['repo'] = this.repo;
    return data;
  }
}

class Kural {
  int? number;
  String? line1;
  String? line2;
  String? translation;
  String? mv;
  String? sp;
  String? mk;
  String? explanation;
  String? couplet;
  String? transliteration1;
  String? transliteration2;

  Kural(
      {this.number,
        this.line1,
        this.line2,
        this.translation,
        this.mv,
        this.sp,
        this.mk,
        this.explanation,
        this.couplet,
        this.transliteration1,
        this.transliteration2});

  Kural.fromJson(Map<String, dynamic> json) {
    number = json['Number'];
    line1 = json['Line1'];
    line2 = json['Line2'];
    translation = json['Translation'];
    mv = json['mv'];
    sp = json['sp'];
    mk = json['mk'];
    explanation = json['explanation'];
    couplet = json['couplet'];
    transliteration1 = json['transliteration1'];
    transliteration2 = json['transliteration2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Number'] = this.number;
    data['Line1'] = this.line1;
    data['Line2'] = this.line2;
    data['Translation'] = this.translation;
    data['mv'] = this.mv;
    data['sp'] = this.sp;
    data['mk'] = this.mk;
    data['explanation'] = this.explanation;
    data['couplet'] = this.couplet;
    data['transliteration1'] = this.transliteration1;
    data['transliteration2'] = this.transliteration2;
    return data;
  }
}
