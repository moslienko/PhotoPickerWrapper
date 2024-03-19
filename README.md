<p align="center">
   <img width="200" src="https://raw.githubusercontent.com/SvenTiigi/SwiftKit/gh-pages/readMeAssets/SwiftKitLogo.png" alt="PhotoPickerWrapper Logo">
</p>

<p align="center">
   <a href="https://developer.apple.com/swift/">
      <img src="https://img.shields.io/badge/Swift-5.2-orange.svg?style=flat" alt="Swift 5.2">
   </a>
   <a href="https://github.com/apple/swift-package-manager">
      <img src="https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg" alt="SPM">
   </a>
</p>

# PhotoPickerWrapper

<p align="center">
ℹ️ UIKit and SwiftUI wrapping library to select photo and video from gallery or camera 
</p>

## Installation

### Swift Package Manager

To integrate using Apple's [Swift Package Manager](https://swift.org/package-manager/), add the following as a dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/moslienko/PhotoPickerWrapper", from: "1.0.0")
]
```

Alternatively navigate to your Xcode project, select `Swift Packages` and click the `+` icon to search for `RegionBlocker`.

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate RegionBlocker into your project manually. Simply drag the `Sources` Folder into your Xcode project.

## Usage

### UIKit

```swift

```

### SwiftUI

```swift
@State var isAlertFotDenyGalleryPresented = false
@State var isAlertFotDenyCameraPresented = false
@State var isPhotoPickerPresented = false
@State var isCameraPickerPresented = false
@State var selectedImages: [UIImage] = []
  
    var body: some View {
      MainView()
          .photoPickerErrorAlert(isPresented: $isAlertFotDenyGalleryPresented, type: .photoLibrary())
          .photoPickerErrorAlert(isPresented: $isAlertFotDenyCameraPresented, type: .camera())
          .sheet(isPresented: $isPhotoPickerPresented) {
              PhotoPickerWrapper(params:
                  ImagePickerParams(
                      selectionLimit: 10,
                      sourceType: .photoLibrary()
                  ),
                  didAssetSelected: { assets in
                      selectedImages = assets.images
                  }
              ).view
          }
  }
    
  ...

func openPicker() {
    PhotoPickerWrapper.tryGetPhotoPermission(onAllow: {
        self.selectedImages = []
        self.isPhotoPickerPresented = true
    }, onDeny: {
        self.isAlertFotDenyCameraPresented = true
    })
}
```

### Localization

All localization strings are placed in your application so that you can always customize them. So for all languages in your application, add localization strings with the following keys to your *Localizable.strings* file:

```swift
"ImagePickerLocale.camera_unavailable_title" = "Camera unavailable";
"ImagePickerLocale.gallery_unavailable_title" = "Access to Photos denied";
"ImagePickerLocale.gallery_unavailable_msg" = "To select a photo, allow access to them in the Settings";
"ImagePickerLocale.camera_unavailable_msg" = "To open the camera, allow access to it in the Settings";
"ImagePickerLocale.open_settings" = "Open Settings";
```


### Info.plist

Don't forget to add the fields to your *info.plist*:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>...</string>
<key>NSCameraUsageDescription</key>
<string>...</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>...</string>
```

## License

```
PhotoPickerWrapper
Copyright (c) 2024 Pavel Moslienko 8676976+moslienko@users.noreply.github.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
