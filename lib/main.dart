import 'package:coding_challenge_weather/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      const ProviderScope(
        child: MyApp(),
      ),
    );
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: CustomAppBar(),
        ),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) =>
                const MobileView()),
      ),
    );
  }
}

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        color: Constants.primaryBackgroundColor,
        child: const Row(
          children: [
            Icon(Icons.menu),
            Text('Hamburg'),
          ],
        ));
  }
}

class MobileView extends ConsumerWidget {
  const MobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
        child: Container(
      color: Constants.primaryBackgroundColor,
      width: double.infinity,
      height: double.infinity,
    ));
  }
}
