class InvitationDetails {
  String? email;
  String? name;
  String? lastName;
  String? invitationUrl;

  InvitationDetails({this.name, this.lastName, this.email, this.invitationUrl});

  bool isValid() {
    if (email == null) return false;
    if (invitationUrl == null) return false;

    return true;
  }
}
