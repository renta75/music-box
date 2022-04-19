class UserInfo {
  final String sub;
  final String preferredUsername;
  final String name;
  final String userFullName;
  final String companyName;

  UserInfo({required this.sub, required this.preferredUsername, required this.name, required this.userFullName, required this.companyName});

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    final sub = json['sub'];
    final preferredUsername = json['preferred_username'];
    final name = json['name'];
    final httpMobilityOneClaimsFullName = json['http://matrix.code/claims/FullName'];
    final httpMobilityOneClaimsCompany = json['http://matrix.code/claims/company'];
    return UserInfo(
      sub: sub,
      preferredUsername: preferredUsername,
      name: name,
      userFullName: httpMobilityOneClaimsFullName,
      companyName: httpMobilityOneClaimsCompany,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sub'] = sub;
    data['preferred_username'] = preferredUsername;
    data['name'] = name;
    data['http://matrix.code/claims/FullName'] = userFullName;
    data['http://matrix.code/claims/company'] = companyName;
    return data;
  }
}
