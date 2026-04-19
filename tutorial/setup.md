# Setup

Keep the repository root for shared files like `README.md`, `LICENSE`, `.gitignore`, `.github/`, `justfile`, and `tutorial/`.

Put all Flutter code inside a single `workspace/` folder.

This tutorial builds a local Flutter prism-face cropper with a fixed normalized face-selection map, deterministic crop-plan math, and one preview slot per canonical face.

From the repository root, run each setup command and checkpoint it before moving to the next one:

```bash
rm -rf workspace

mkdir -p workspace

flutter create --platforms=web,android,ios,macos,windows,linux --org com.intrepion --project-name prism_face_cropper workspace
git add --all
git commit --message "flutter create --platforms=web,android,ios,macos,windows,linux --org com.intrepion --project-name prism_face_cropper workspace"

rm workspace/test/widget_test.dart
git add --all
git commit --message "rm workspace/test/widget_test.dart"

(cd workspace && flutter pub add --dev test)
just format
git add --all
git commit --message "(cd workspace && flutter pub add --dev test)"

(cd workspace && flutter pub add --dev mocktail)
just format
git add --all
git commit --message "(cd workspace && flutter pub add --dev mocktail)"

(cd workspace && flutter pub add --dev integration_test --sdk flutter)
just format
git add --all
git commit --message "(cd workspace && flutter pub add --dev integration_test --sdk flutter)"
```

When the full workspace is finished, it should contain these files:

```text
workspace/
  pubspec.yaml
  lib/
    contracts/
      normalized_rect.dart
      face_crop_plan.dart
      face_selection_validation.dart
    code/
      prism_face_cropper_service.dart
    adapter/
      prism_face_cropper_page.dart
  test/
    code/
      prism_face_cropper_service_test.dart
    adapter/
      prism_face_cropper_page_test.dart
  integration_test/
    app_test.dart
  lib/main.dart
```

Before you try any run command, make sure Flutter can see a supported target:

```bash
just devices
```

For web, use the default web command:

```bash
just run
```

or, explicitly:

```bash
just run-web
```

On macOS for iOS, install CocoaPods first if you have not already:

```bash
sudo gem install cocoapods
```

Then open the simulator, list devices, and run the iOS app with an actual simulator id or name:

```bash
open -a Simulator
just devices
just run-ios device="<ios-device-id-or-name>"
```

Flutter does not accept bare `ios` as a generic simulator target, so if `just devices` does not show your simulator yet, wait a moment and run it again.

For Android, list available emulators, launch one, list devices again, and then run the Android app:

```bash
just emulators
flutter emulators --launch <emulator-id>
just devices
just run-android device="<android-device-id-or-name>"
```

For macOS desktop, use:

```bash
just run-macos
```

For Windows or Linux, run the matching command on that host platform:

```bash
just run-windows
just run-linux
```

After your first successful iOS run, if CocoaPods added shared iOS project files like these:

- `workspace/ios/Runner.xcodeproj/project.pbxproj`
- `workspace/ios/Runner.xcworkspace/contents.xcworkspacedata`
- `workspace/ios/Podfile.lock`

then run:

```bash
git add --all
git commit --message "Add iOS CocoaPods workspace files"
```

After your first successful macOS run, if CocoaPods added shared macOS project files like these:

- `workspace/macos/Runner.xcodeproj/project.pbxproj`
- `workspace/macos/Runner.xcworkspace/contents.xcworkspacedata`
- `workspace/macos/Podfile.lock`

then run:

```bash
git add --all
git commit --message "Add macOS CocoaPods workspace files"
```

Do not commit local machine output like these:

- `workspace/ios/Pods/`
- `workspace/macos/Pods/`
- `workspace/build/`
- `workspace/.dart_tool/`

For Android, a normal first run usually should not add shared tracked files. If it does change shared files under `workspace/android/`, review them carefully and commit only the project-level changes. Do not commit machine-specific files like:

- `workspace/android/local.properties`
- `workspace/.gradle/`
- `workspace/build/`
