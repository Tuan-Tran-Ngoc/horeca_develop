# !/bin/bash
flutter pub run build_runner build --delete-conflicting-outputs
flutter build apk --split-per-abi
flutter pub run flutter_launcher_icons:main
flutter gen-l10n