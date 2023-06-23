<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Flutter gif picker with Tenor Service.

<img src='scr.png' height="400"/>

## Getting started

Add Dependency to Flutter
```yaml
dependencies:
  flutter_tenor_gif_picker: ^0.0.1
```

## Usage

### Initialize
```dart
TenorGifPicker.init(
      apiKey: 'YOUR_API_KEY',
      locale: 'en_IN',
      clientKey: 'test_app',
      country: 'IN'
  );
```
### Open as Bottomsheet

```dart
TenorGifPickerPage.showAsBottomSheet(context);
```
### Open as Page

```dart
TenorGifPickerPage.openAsPage(context,);
```

### Additional Parameters

- PreLoad Text

```dart
TenorGifPickerPage.showAsBottomSheet(
                  context,
                  preLoadText: 'cricket, football',
                ).then(
                  (tenorData) {
                    print("Selection $tenorData");
                  },
                );
```
- Custom Categories

```dart
TenorGifPickerPage.showAsBottomSheet(
                  context,
                  customCategories: [
                    'HaHa',
                    'Love',
                    'Sports',
                    'Memes',
                    'Reaction'
                  ],
                ).then(
                  (tenorData) {
                    print("Selection $tenorData");
                  },
                );
```
- Hide/Show category

```dart
TenorGifPickerPage.showAsBottomSheet(
                  context,
                  showCategory: true,
                  categoryType: CategoryType.featured,
                ).then(
                  (tenorData) {
                    print("Selection $tenorData");
                  },
                );


```
Category Type (enum):
```dart
CategoryType.featured, CategoryType.trending
```

`default category type is CategoryType.featured`

## Additional information

See TenorApiService also [Click here](https://github.com/hudle/FlutterTenorApiService)
