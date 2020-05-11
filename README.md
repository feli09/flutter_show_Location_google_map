# flutter_app_google_map

A new Flutter application .

Show your location on the google map .

Use GeoCode to get address by lat / lon.

# Please Change Google Map API Key .

Android:

app/src/main/AndroidManifestxml 
```bash
 <meta-data
            android:name="com.google.android.geo.API_KEY"
            android:value="your api key" />"
```         
iOS:

Runner/AppDelegate.swift

```bash
// Add the following line, with your API key
GMSServices.provideAPIKey("your api key")
return super.application(application, didFinishLaunchingWithOptions: launchOptions)
``` 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
