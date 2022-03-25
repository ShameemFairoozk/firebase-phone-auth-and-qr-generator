// To parse this JSON data, do
//
//     final ipModel = ipModelFromJson(jsonString);

import 'dart:convert';

IpModel ipModelFromJson(String str) => IpModel.fromJson(json.decode(str));

String ipModelToJson(IpModel data) => json.encode(data.toJson());

class IpModel {
  IpModel({
    required this.status,
    required this.country,
    required this.countryCode,
    required this.region,
    required this.regionName,
    required this.city,
    required this.zip,
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.isp,
    required this.org,
    required this.ipModelAs,
    required this.query,
  });

  String status;
  String country;
  String countryCode;
  String region;
  String regionName;
  String city;
  String zip;
  double lat;
  double lon;
  String timezone;
  String isp;
  String org;
  String ipModelAs;
  String query;

  factory IpModel.fromJson(Map<String, dynamic> json) => IpModel(
    status: json["status"],
    country: json["country"],
    countryCode: json["countryCode"],
    region: json["region"],
    regionName: json["regionName"],
    city: json["city"],
    zip: json["zip"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    timezone: json["timezone"],
    isp: json["isp"],
    org: json["org"],
    ipModelAs: json["as"],
    query: json["query"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "country": country,
    "countryCode": countryCode,
    "region": region,
    "regionName": regionName,
    "city": city,
    "zip": zip,
    "lat": lat,
    "lon": lon,
    "timezone": timezone,
    "isp": isp,
    "org": org,
    "as": ipModelAs,
    "query": query,
  };
}
