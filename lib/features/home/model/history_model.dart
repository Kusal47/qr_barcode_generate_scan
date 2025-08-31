class HistoryModel {
    String? url;
  String? title;
   String? ssid;
  String? password;
  String? wifiType;

  HistoryModel({this.url, this.title, this.ssid, this.password, this.wifiType});

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      url: json['url'],
      title: json['title'],
      ssid: json['ssid'],
      password: json['password'],
      wifiType: json['wifiType'],
    );
  }
}