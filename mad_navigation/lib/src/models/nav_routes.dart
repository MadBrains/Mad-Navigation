part of 'navigation_models.dart';

/// Represents an unknown page route.
///
/// This route is typically used as a fallback when an unknown route is encountered.
class PageUnknown extends NavPage<Never> {
  /// Creates a new unknown page route.
  PageUnknown() : super('unknown');
}

/// Represents an unknown dialog route.
///
/// This route is used as a fallback when an unknown dialog route is encountered.
class DialogUnknown extends NavDialog<Never> {
  /// Creates a new unknown dialog route.
  DialogUnknown() : super('unknown');
}

/// Represents an unknown bottom sheet route.
///
/// This route is used as a fallback when an unknown bottom sheet route is encountered.
class BottomSheetUnknown extends NavBottomSheet<Never> {
  /// Creates a new unknown bottom sheet route.
  BottomSheetUnknown() : super('unknown');
}
