/// Pure Dart: implementation of navigation logic, can be used independently or customized
///
/// This package contains concrete implementations of the navigation services
/// and utilities defined in the core `package:mad_navigation` package.
/// It provides a complete, ready-to-use navigation solution that can be
/// customized or extended as needed.
///
/// To use this implementation, import the library:
/// ```dart
/// import 'package:mad_navigation_impl/mad_navigation_impl.dart';
/// ```
library mad_navigation_impl;

export 'package:mad_navigation/mad_navigation.dart';

export 'src/mad_navigation_service_impl/mad_navigation_service_impl.dart';
export 'src/mad_tab_navigation_service_impl/mad_tab_navigation_service_impl.dart';
export 'src/mad_utils.dart';
