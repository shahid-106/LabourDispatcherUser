class JobLog {
  String companyId;
  String imageFileName;
  String imageUrl;
  String jobDesc;
  String jobFlag;
  String jobNumber;
  String jobPin;
  String jobRate;
  String jobHours;
  String pdfFileName;
  String pdfUrl;
  String priceQuote;
  String quantity;
  String startLatitude;
  String startLongitude;
  String startTime;
  String startingTeg;
  String stopLatitude;
  String stopLongitude;
  String stopTime;
  String stopingTeg;
  String uid;

  JobLog(
      {this.companyId,
        this.imageFileName,
        this.imageUrl,
        this.jobDesc,
        this.jobFlag,
        this.jobNumber,
        this.jobPin,
        this.jobRate,
        this.jobHours,
        this.pdfFileName,
        this.pdfUrl,
        this.priceQuote,
        this.quantity,
        this.startLatitude,
        this.startLongitude,
        this.startTime,
        this.startingTeg,
        this.stopLatitude,
        this.stopLongitude,
        this.stopTime,
        this.stopingTeg,
        this.uid});

  JobLog.fromJson(Map<String, dynamic> json) {
    // print(json['uid']);
    companyId = json['companyId'] == null ? "" : json['companyId'].toString();
    imageFileName = json['imageFileName'] == null ? "" : json['imageFileName'].toString();
    imageUrl = json['imageUrl'] == null ? "" : json['imageUrl'].toString();
    jobDesc = json['jobDesc'] == null ? "" : json['jobDesc'].toString();
    jobFlag = json['jobFlag'] == null ? "" : json['jobFlag'].toString();
    jobNumber = json['jobNumber'] == null ? "" : json['jobNumber'].toString();
    jobPin = json['jobPin'] == null ? "" : json['jobPin'].toString();
    jobRate = json['jobRate'] == null ? "" : json['jobRate'].toString();
    jobHours = json['job_hours'] == null ? "" : json['job_hours'].toString();
    pdfFileName = json['pdfFileName'] == null ? "" : json['pdfFileName'].toString();
    pdfUrl = json['pdfUrl'] == null ? "" : json['pdfUrl'].toString();
    priceQuote = json['priceQuote'] == null ? "" : json['priceQuote'].toString();
    quantity = json['quantity'] == null ? "" : json['quantity'].toString();
    startLatitude = json['start_latitude'] == null ? "" : json['start_latitude'].toString();
    startLongitude = json['start_longitude'] == null ? "" : json['start_longitude'].toString();
    startTime = json['start_time'] == null ? "" : json['start_time'].toString();
    startingTeg = json['starting_teg'] == null ? "" : json['starting_teg'].toString();
    stopLatitude = json['stop_latitude'] == null ? "" : json['stop_latitude'].toString();
    stopLongitude = json['stop_longitude'] == null ? "" : json['stop_longitude'].toString();
    stopTime = json['stop_time'] == null ? "" : json['stop_time'].toString();
    stopingTeg = json['stoping_teg'] == null ? "" : json['stoping_teg'].toString();
    uid = json['uid'] == null ? "" : json['uid'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['imageFileName'] = this.imageFileName;
    data['imageUrl'] = this.imageUrl;
    data['jobDesc'] = this.jobDesc;
    data['jobFlag'] = this.jobFlag;
    data['jobNumber'] = this.jobNumber;
    data['jobPin'] = this.jobPin;
    data['jobRate'] = this.jobRate;
    data['job_hours'] = this.jobHours;
    data['pdfFileName'] = this.pdfFileName;
    data['pdfUrl'] = this.pdfUrl;
    data['priceQuote'] = this.priceQuote;
    data['quantity'] = this.quantity;
    data['start_latitude'] = this.startLatitude;
    data['start_longitude'] = this.startLongitude;
    data['start_time'] = this.startTime;
    data['starting_teg'] = this.startingTeg;
    data['stop_latitude'] = this.stopLatitude;
    data['stop_longitude'] = this.stopLongitude;
    data['stop_time'] = this.stopTime;
    data['stoping_teg'] = this.stopingTeg;
    data['uid'] = this.uid;
    return data;
  }
}