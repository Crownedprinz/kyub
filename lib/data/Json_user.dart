class JsonUser {
  String accessToken;

  JsonUser({
    this.accessToken,
  });

  factory JsonUser.fromSuccess(Map<String, dynamic> parsedJson) {
    return JsonUser(
      accessToken: parsedJson['message'],
    );
  }
  factory JsonUser.fromError(Map<String, dynamic> parsedJson) {
    return JsonUser(
      accessToken: parsedJson['Message'],
    );
  }
}