// import 'package:flutter/material.dart';
// import 'package:support_app/routes.dart';
// import 'package:responsive_framework/responsive_framework.dart';
// import 'package:support_app/screens/login/login.dart';
// import 'package:support_app/splash/splashscreen.dart';
// void main(){
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return  MaterialApp(
//       builder: (context, child) => ResponsiveWrapper.builder(
//           child,
//           maxWidth: 1200,
//           minWidth: 480,
//           defaultScale: true,
//           breakpoints: [
//             const ResponsiveBreakpoint.resize(480, name: MOBILE),
//             const ResponsiveBreakpoint.autoScale(800, name: TABLET),
//             const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
//             const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
//           ],
//           // background: Container(color: const Color(0xFFF5F5F5))
//       ),
//
//       debugShowCheckedModeBanner: false,
//       title: "Cubixsys Support",
//       theme: ThemeData(),
//       home: const SplashScreen(),
//       // initialRoute: Login.routeName,
//       routes: routes,
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:support_app/routes.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:support_app/splash/splashscreen.dart';
Future<void> main()  async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
        ],
        // background: Container(color: const Color(0xFFF5F5F5))
      ),
      debugShowCheckedModeBanner: false,
      title: "Cubixsys Support",
      theme: ThemeData(),
      // home: const SignIn(),
      home: const SplashScreen(),
      // initialRoute: Login.routeName,
      routes: routes,
    );
  }
}
