// import 'dart:io'; // For using the File class
// import 'dart:convert'; // For encoding and decoding JSON
// import 'package:jose/jose.dart'; // For JWT creation
// import 'package:http/http.dart' as http; // For making HTTP requests

// // Function to create a JWT (JSON Web Token)
// String createJWT(String serviceAccountEmail, String privateKey) {
//   final builder = JsonWebSignatureBuilder()
//     ..jsonContent = {
//       'iss': serviceAccountEmail,
//       'scope': 'https://www.googleapis.com/auth/firebase.messaging',
//       'aud': 'https://oauth2.googleapis.com/token',
//       'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
//       'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
//     }
//     ..addRecipient(JsonWebKey.fromPem(privateKey), algorithm: 'RS256');

//   final jws = builder.build();
//   return jws.toCompactSerialization();
// }

// // Function to get an access token using the JWT
// Future<String> getAccessToken(String jwt) async {
//   final response = await http.post(
//     Uri.parse('https://oauth2.googleapis.com/token'),
//     headers: {'Content-Type': 'application/x-www-form-urlencoded'},
//     body: {
//       'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
//       'assertion': jwt,
//     },
//   );

//   if (response.statusCode == 200) {
//     final Map<String, dynamic> json = jsonDecode(response.body);
//     return json['access_token'];
//   } else {
//     throw Exception('Failed to get access token: ${response.body}');
//   }
// }

// // Function to load the service account key from a file
// Map<String, dynamic> loadServiceAccount(String filePath) {
//   final file = File(filePath);
//   final contents = file.readAsStringSync();
//   return jsonDecode(contents);
// }

// void main() async {
//   try {
//     // Load service account details from a file
//     final serviceAccount = loadServiceAccount('/Users/anirudharkery/Downloads/safe-walk-v3-firebase-adminsdk-cxqic-8256b42be4.json');
//     final serviceAccountEmail = serviceAccount['client_email'];
//     final privateKey = serviceAccount['private_key'];

//     // Create a JWT
//     final jwt = createJWT(serviceAccountEmail, privateKey);
//     print('JWT: $jwt');

//     // Get the access token using the JWT
//     final accessToken = await getAccessToken(jwt);
//     print('Access Token: $accessToken');

//     // You can now use the access token to send a test FCM notification
//     // (Implementation of the notification sending is not included here)

//   } catch (e) {
//     print('Error: $e');
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:jose/jose.dart';
import 'package:http/http.dart' as http;

String createJWT(String serviceAccountEmail, String privateKey) {
  final builder = JsonWebSignatureBuilder()
    ..jsonContent = {
      'iss': serviceAccountEmail,
      'scope': 'https://www.googleapis.com/auth/firebase.messaging',
      'aud': 'https://oauth2.googleapis.com/token',
      'exp': (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    }
    ..addRecipient(JsonWebKey.fromPem(privateKey), algorithm: 'RS256');

  final jws = builder.build();
  return jws.toCompactSerialization();
}

Future<String> getAccessToken(String jwt) async {
  final response = await http.post(
    Uri.parse('https://oauth2.googleapis.com/token'),
    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
    body: {
      'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      'assertion': jwt,
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);
    return json['access_token'];
  } else {
    throw Exception('Failed to get access token: ${response.body}');
  }
}

Map<String, dynamic> loadServiceAccount(String filePath) {
  final file = File(filePath);
  final contents = file.readAsStringSync();
  return jsonDecode(contents);
}

void main() async {
  try {
    final serviceAccount = loadServiceAccount('/Users/anirudharkery/Downloads/safe-walk-v3-firebase-adminsdk-cxqic-8256b42be4.json');
    final serviceAccountEmail = serviceAccount['client_email'];
    final privateKey = serviceAccount['private_key'];

    final jwt = createJWT(serviceAccountEmail, privateKey);
    print('JWT: $jwt');

    final accessToken = await getAccessToken(jwt);
    print('Access Token: $accessToken');

    // You can now use the access token to send a test FCM notification
    // (Implementation of the notification sending is not included here)

  } catch (e) {
    print('Error: $e');
  }
}
