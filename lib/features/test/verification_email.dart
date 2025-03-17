// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'package:uni_links/uni_links.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String verificationStatus = "Waiting for email verification...";
//
//   @override
//   void initState() {
//
//     super.initState();
//     _handleDeepLinks();
//   }
//
//   void _handleDeepLinks() async {
//     uriLinkStream.listen((Uri? uri) {
//       if (uri != null && uri.path == "/email-verify") {
//         String? emailToken = uri.queryParameters["emailToken"];
//         if (emailToken != null) {
//           _verifyEmail(emailToken);
//         }
//       }
//     });
//   }
//
//   Future<void> _verifyEmail(String emailToken) async {
//     final String apiUrl = "https://light-master-eagle.ngrok-free.app/api/v1/user/verifyemail"; // Replace with your API
//
//     try {
//       final response = await http.patch(
//         Uri.parse(apiUrl),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({"emailToken": emailToken}),
//       );
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200 && responseData["status"] == "success") {
//         setState(() {
//           verificationStatus = "Your email has been verified successfully!";
//         });
//       } else {
//         setState(() {
//           verificationStatus = "Email verification failed!";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         verificationStatus = "Error verifying email!";
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: Text("Email Verification")),
//         body: Center(child: Text(verificationStatus)),
//       ),
//     );
//   }
// }