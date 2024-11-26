import 'package:flutter/material.dart';
import './screens/NewScreen.dart';
import '././widgets/MyWidget.dart';
import '././screens/login_screen.dart';

// import 'package:flutter/material.dart';
// import './screens/login_screen.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(),
    home: SafeArea(
      child: Scaffold(
        body: LoginScreen(), // Sử dụng LoginScreen làm màn hình khởi đầu
      ),
    ),
    debugShowCheckedModeBanner: false,
  ));
}

// void main() {
//   runApp(MaterialApp(
//     theme: ThemeData(),
//     home: SafeArea(child: Scaffold(
//       body: MyWidget(),
//     )),
//     debugShowCheckedModeBanner: false,
//   ));
// }
//
// class MyWidget extends StatelessWidget {
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // Viết code ở đây
//       child: ElevatedButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => NewScreen()),
//             );
//           },
//           child: const Text('Click để chuyển qua màn hình mới!')),
//     );
//   }
// }

// class NewScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(title: const Text("Màn hình mới")),
//         body: const Text("Đây là màn hình mới!"),
//       ),
//     );
//   }
//
// }