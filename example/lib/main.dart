import 'package:flutter/material.dart';
import 'package:flutter_tenor_gif_picker/flutter_tenor_gif_picker.dart';

void main() {
  TenorGifPicker.init(
      apiKey: 'AIzaSyDRXyttY5JX2_tS8ewP8yALV_u6eYr3nHU',
      locale: 'en_IN',
      clientKey: 'test_app',
      country: 'IN');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Picker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _HomeApp(),
    );
  }
}

class _HomeApp extends StatelessWidget {
  const _HomeApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                TenorGifPickerPage.showAsBottomSheet(
                  context,
                  showCategory: true,
                  customCategories: [
                    'HaHa',
                    'Love',
                    'Sports',
                    'Memes',
                    'Reaction'
                  ],
                  preLoadText: 'cricket, football',
                  categoryType: CategoryType.featured,
                ).then(
                  (tenorData) {
                    print("Selection $tenorData");
                  },
                );
              },
              child: Text("Show  Picker"),
            ),
            TextButton(
              onPressed: () {
                TenorGifPickerPage.openAsPage(
                  context,
                );
              },
              child: Text("Show Page"),
            ),
          ],
        ),
      ),
    );
  }
}
