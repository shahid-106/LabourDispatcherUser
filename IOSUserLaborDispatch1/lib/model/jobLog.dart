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
    companyId = json['companyId'];
    imageFileName = json['imageFileName'];
    imageUrl = json['imageUrl'];
    jobDesc = json['jobDesc'];
    jobFlag = json['jobFlag'];
    jobNumber = json['jobNumber'];
    jobPin = json['jobPin'];
    jobRate = json['jobRate'];
    jobHours = json['job_hours'];
    pdfFileName = json['pdfFileName'];
    pdfUrl = json['pdfUrl'];
    priceQuote = json['priceQuote'];
    quantity = json['quantity'];
    startLatitude = json['start_latitude'];
    startLongitude = json['start_longitude'];
    startTime = json['start_time'];
    startingTeg = json['starting_teg'];
    stopLatitude = json['stop_latitude'];
    stopLongitude = json['stop_longitude'];
    stopTime = json['stop_time'];
    stopingTeg = json['stoping_teg'];
    uid = json['uid'];
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