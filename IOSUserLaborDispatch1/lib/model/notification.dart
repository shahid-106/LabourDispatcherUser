class NotificationModel {
  String title;
  String body;
  String companyId;

  NotificationModel({this.title, this.body, this.companyId});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    companyId = json['companyId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    data['companyId'] = this.companyId;
    return data;
  }
}