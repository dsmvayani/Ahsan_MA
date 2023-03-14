

class AuthCredentials {
  
  final String token;
  final String userId;
  final String? password;
  AuthCredentials({
    required this.token,
    required this.userId,  this.password
  });
}