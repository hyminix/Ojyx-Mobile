// Temporary workaround for gtk 2.1.0 compilation issue with Dart 3.8
// This file is not used in the project, but serves as documentation

/* 
The gtk package version 2.1.0 has a syntax error that's incompatible with Dart 3.8+.
The issue is in /lib/src/gtk_application.dart line 33:
    (super as dynamic).key,

This syntax is no longer valid in newer Dart versions.

Solutions:
1. Wait for gtk package update
2. Use dependency override (not working due to no newer version)
3. Exclude Linux platform when building for Android
4. Manually patch the package (not recommended)
*/