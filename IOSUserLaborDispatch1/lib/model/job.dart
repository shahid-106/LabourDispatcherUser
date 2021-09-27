import 'dart:convert';

class Job {
  String quantity;
  String stopTime;
  String jobDate;
  String jobHours;
  String startingTeg;
  AddressModel adress;
  String jobDesc;
  String jobFlag;
  String startLongitude;
  String startTime;
  String companyId;
  String pdfUrl;
  String jobPin;
  String priceQuote;
  String startLatitude;
  String jobRate;
  String stopingTeg;
  String pdfFileName;
  String jobNumber;

  Job(
      {this.quantity,
        this.stopTime,
        this.jobDate,
        this.jobHours,
        this.startingTeg,
        this.adress,
        this.jobDesc,
        this.jobFlag,
        this.startLongitude,
        this.startTime,
        this.companyId,
        this.pdfUrl,
        this.jobPin,
        this.priceQuote,
        this.startLatitude,
        this.jobRate,
        this.stopingTeg,
        this.pdfFileName,
        this.jobNumber});

  Job.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'].toString();
    stopTime = json['stop_time'].toString();
    jobDate = json['jobDate'].toString();
    jobHours = json['job_hours'].toString();
    startingTeg = json['starting_teg'].toString();
    adress = json['adress'] != null ? new AddressModel.fromJson(jsonDecode(json['adress'])) : null;
    jobDesc = json['jobDesc'].toString();
    jobFlag = json['jobFlag'].toString();
    startLongitude = json['start_longitude'].toString();
    startTime = json['start_time'].toString();
    companyId = json['companyId'].toString();
    pdfUrl = json['pdfUrl'].toString();
    jobPin = json['jobPin'].toString();
    priceQuote = json['priceQuote'].toString();
    startLatitude = json['start_latitude'].toString();
    jobRate = json['jobRate'].toString();
    stopingTeg = json['stoping_teg'].toString();
    pdfFileName = json['pdfFileName'].toString();
    jobNumber = json['jobNumber'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['stop_time'] = this.stopTime;
    data['jobDate'] = this.jobDate;
    data['job_hours'] = this.jobHours;
    data['starting_teg'] = this.startingTeg;
    if (this.adress != null) {
      data['adress'] = json.encode(this.adress.toJson());
    }
    data['jobDesc'] = this.jobDesc;
    data['jobFlag'] = this.jobFlag;
    data['start_longitude'] = this.startLongitude;
    data['start_time'] = this.startTime;
    data['companyId'] = this.companyId;
    data['pdfUrl'] = this.pdfUrl;
    data['jobPin'] = this.jobPin;
    data['priceQuote'] = this.priceQuote;
    data['start_latitude'] = this.startLatitude;
    data['jobRate'] = this.jobRate;
    data['stoping_teg'] = this.stopingTeg;
    data['pdfFileName'] = this.pdfFileName;
    data['jobNumber'] = this.jobNumber;
    return data;
  }
}

class AddressModel {
  String city;
  String latitude;
  String longitude;
  String state;
  String streetName;
  String streetNo;
  String tellePhone;
  String zipCode;

  AddressModel(
      {this.city,
        this.latitude,
        this.longitude,
        this.state,
        this.streetName,
        this.streetNo,
        this.tellePhone,
        this.zipCode});

  AddressModel.fromJson(Map<String, dynamic> json) {
    city = json['city'].toString();
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
    state = json['state'].toString();
    streetName = json['streetName'].toString();
    streetNo = json['streetNo'].toString();
    tellePhone = json['tellePhone'].toString();
    zipCode = json['zipCode'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['state'] = this.state;
    data['streetName'] = this.streetName;
    data['streetNo'] = this.streetNo;
    data['tellePhone'] = this.tellePhone;
    data['zipCode'] = this.zipCode;
    return data;
  }

  Map<String, dynamic> toJsonWithoutCoordinates() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['city'] = this.city;
    // data['latitude'] = this.latitude;
    // data['longitude'] = this.longitude;
    data['state'] = this.state;
    data['streetName'] = this.streetName;
    data['streetNo'] = this.streetNo;
    data['tellePhone'] = this.tellePhone;
    data['zipCode'] = this.zipCode;
    return data;
  }
}